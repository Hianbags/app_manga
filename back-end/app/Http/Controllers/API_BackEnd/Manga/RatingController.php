<?php
namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\Manga\Manga;
use App\Models\Manga\Rating;
use Illuminate\Http\Request;
 
use Illuminate\Support\Facades\Auth;

class RatingController extends Controller
{
    public function store(Request $request, $mangaId)
{
    try {
        $request->validate([
            'rating' => 'required|integer|min:1|max:10',
        ]);

        // Kiểm tra xem user đã đánh giá truyện này chưa
        $existingRating = Rating::where('manga_id', $mangaId)
            ->where('user_id', Auth::id())
            ->first();

        if ($existingRating) {
            return response()->json(['error' => 'You have already rated this manga'], 403);
        }

        // Tạo mới đánh giá
        Rating::create([
            'manga_id' => $mangaId,
            'user_id' => Auth::id(),
            'rating' => $request->input('rating'),
        ]);

        // Cập nhật rating trung bình của truyện
        Manga::find($mangaId)->update([
            'rating' => Rating::where('manga_id', $mangaId)->avg('rating'),
        ]);

        return response()->json(['message' => 'Rating saved successfully'], 200);
    } catch (\Exception $e) {
        // Ghi log lỗi nếu cần thiết
        // Log::error($e->getMessage());
        return response()->json(['error' => 'An error occurred while saving the rating'], 500);
    }
}

}
