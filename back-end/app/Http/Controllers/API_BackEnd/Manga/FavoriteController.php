<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Resources\FavoriteResource;
use App\Models\Manga\Favorite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller 
{
    public function index()
    {
        try {
            $favorites = Favorite::where('user_id', Auth::id())->with('manga')->select('id','user_id','manga_id')->get();
            return response()->json([
                'status' => 'success',
                'data' => ($favorites),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function store(Request $request)
    {
        $this->validate($request, [
            'manga_id' => 'required|exists:mangas,id',
        ]);
        try {
            // Kiểm tra xem mục yêu thích đã tồn tại chưa
            $favorite = Favorite::where('user_id', Auth::id())
                                ->where('manga_id', $request->input('manga_id'))
                                ->first();
            if ($favorite) {
                // Nếu đã tồn tại mục yêu thích, xóa nó đi
                $favorite->delete();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Manga removed from favorites',
                ]);
            } else {
                // Nếu chưa tồn tại, thêm vào mục yêu thích
                $newFavorite = new Favorite();
                $newFavorite->user_id = Auth::id();
                $newFavorite->manga_id = $request->input('manga_id');
                $newFavorite->save();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Manga added to favorites',
                    'data' => $newFavorite,
                ]);
            }
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }


}