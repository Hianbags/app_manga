<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Resources\MangaBannerCollectionResource;
use App\Http\Resources\MangaCollectResource;
use App\Http\Resources\MangaResource;
use App\Models\Manga\Manga;
use Illuminate\Http\Request;
use App\Http\Resources\MangaSearchResource;

class MangaController extends Controller
{
    public function getMangasByCategoryIds(Request $request)
    {
    // Validate the incoming request
    $request->validate([
        'category_ids' => 'required|array',
        'category_ids.*' => 'integer',
    ]);
    $categoryIds = $request->input('category_ids');
    $manga = Manga::whereHas('categories', function($query) use ($categoryIds) {
        $query->whereIn('categories.id', $categoryIds);
    })->paginate(5);
    // Return the products as a JSON response
        return new MangaCollectResource($manga);
    }
    public function search(Request $request)
    {
        $query = Manga::query()->take(5);
    
        if ($request->filled('title')) {
            $query->where('title', 'like', '%' . $request->input('title') . '%');
        }
        if ($request->filled('author')) {
            $query->where('author', 'like', '%' . $request->input('author') . '%');
        }
    
        $manga = $query->get();
    
        return response()->json([
            'status' => 'success',
            'data' => MangaSearchResource::collection($manga),
        ]);
    }
    public function index()
    {
        $manga = Manga::query()->paginate(6);
        return new MangaCollectResource($manga);
    }

    public function indexAdmin()
    {
        $manga = Manga::all();
        return response()->json([
            'status' => 'success',
            'data' => $manga,
        ]);
    }
    public function sortview()
    {
        $manga = Manga::orderBy('views', 'desc')->limit(5)->get();
        return response()->json([
            'status' => 'success',
            'data' => MangaBannerCollectionResource::collection($manga),
        ]);
    }
    public function mostViewByTime($time)
    {
        $manga = Manga::orderBy('views', 'desc')->where('created_at', '>=', \Carbon\Carbon::now()->subDays($time))->get();
        return response()->json([
            'status' => 'success',
            'data' => MangaCollectResource::collection($manga),
        ]);
    }
    public function show($id)
    {
        try{
            $manga = Manga::findOrFail($id);
        if (empty($manga)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Manga not found',
            ], 404);
        }
        return response()->json([
            'status' => 'success',
            'data' => new MangaResource($manga),
        ]);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function store(Request $request)
    {
        $this->validate($request, [
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'title' => 'required',
            'author' => 'required',
            'description' => 'required',
            'status' => 'required|in:completed,ongoing,dropped',
            'category_ids' => 'required|array',
            'category_ids.*' => 'exists:categories,id',
        ]);
        try {
            $image = $request->file('image');
            $image_name = time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('images'), $image_name);
            $requestData = $request->all();
            $requestData['image'] = 'images/'.$image_name;
            $manga = Manga::create($requestData);
            $manga->categories()->attach($request->category_ids);
            return response()->json([
                'status' => 'success',
                'message' => 'Manga created',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function update(Request $request, $id)
    {
        $this->validate($request, [
            'image' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'title' => 'required',
            'author' => 'required',
            'description' => 'required',
            'status' => 'required|in:completed,ongoing,dropped',
            'category_ids' => 'required|array',
            'category_ids.*' => 'exists:categories,id',
        ]);
    
        try {
            $manga = Manga::findOrFail($id);
    
            // Xử lý hình ảnh nếu có thay đổi
            if ($request->hasFile('image')) {
                // Xóa ảnh cũ nếu có
                if ($manga->image && file_exists(public_path($manga->image))) {
                    unlink(public_path($manga->image));
                }
    
                $image = $request->file('image');
                $image_name = time() . '.' . $image->getClientOriginalExtension();
                $image->move(public_path('images'), $image_name);
                $requestData['image'] = 'images/' . $image_name;
            } else {
                $requestData['image'] = $manga->image; // Giữ nguyên ảnh cũ nếu không có thay đổi
            }
    
            $requestData = $request->all();
            $manga->update($requestData);
    
            // Cập nhật các category
            $manga->categories()->sync($request->category_ids);
    
            return response()->json([
                'status' => 'success',
                'message' => 'Manga updated',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    
    public function destroy($id)
    {
        try {
            $manga = Manga::findOrFail($id);
            if (empty($manga)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Manga not found',
                ], 404);
            }
            $manga->delete();
            return response()->json([
                'status' => 'success',
                'message' => 'Manga deleted',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
