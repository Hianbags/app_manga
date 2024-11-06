<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Resources\MangaCollectResource;
use App\Models\Manga\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CategoryController extends Controller{

    public function index()
    {
        $category = Category::all()->select('id', 'title');
        return response()->json([
            'status' => 'success',
            'data' => $category,
        ]);
    }
    public function show($id)
    {
        try{
           $mangas = DB::table('manga_categories')->where('category_id', $id)->join('mangas', 'manga_categories.manga_id', '=', 'mangas.id')->paginate(5);
        return new MangaCollectResource($mangas);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function store(Request $request)
    {
        $category = new Category();
        $category->title = $request->input('title');
        $category->description = $request->input('description');
        $category->test = $request->input('test');
        $category->save();
        return response()->json([
            'status' => 'success',
            'data' => $category,
        ]);
    }
    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);
        $category->title = $request->input('title');
        $category->description = $request->input('description');
        $category->save();
        return response()->json([
            'status' => 'success',
            'data' => $category,
        ]);
    }
    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();
        return response()->json([
            'status' => 'success',
            'message' => 'Category deleted',
        ]);
    }
    
}