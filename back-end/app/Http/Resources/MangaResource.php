<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;



class MangaResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $user = Auth::guard('api')->user();
        $isFavorite = false;

        if ($user) {
            $isFavorite = DB::table('favorites')
                ->where('user_id', $user->id)
                ->where('manga_id', $this->id)
                ->exists();
        }
        return [
            'id' => $this->id,
            'image' => "https://magiabaiser.id.vn/$this->image",
            'title' => $this->title,
            'author' => $this->author,
            'description' => $this->description,
            'status' => $this->status,
            'rating' => $this->rating,
            'views' => $this->views,
            'favorite' => $isFavorite,
            'updated_at'=> $this->updated_at->format('s:i:H d-m-Y'),
            'categories' => DB::table('manga_categories')
                ->join('categories', 'manga_categories.category_id', '=', 'categories.id')
                ->where('manga_categories.manga_id', $this->id)
                ->select('categories.id' ,'categories.title')
                ->get(),
            'chapters' => DB::table('chapters')
                ->join('pages', 'chapters.id', '=', 'pages.chapter_id')
                ->where('chapters.manga_id', $this->id)
                ->groupBy('chapters.id', 'chapters.title','chapters.created_at')
                ->select('chapters.id', 'chapters.title',DB::raw('CASE 
                                WHEN TIMESTAMPDIFF(HOUR, chapters.created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(MINUTE, chapters.created_at, NOW()), " phút")
                                WHEN TIMESTAMPDIFF(DAY, chapters.created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(HOUR, chapters.created_at, NOW()), " giờ")
                                WHEN TIMESTAMPDIFF(MONTH, chapters.created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(DAY, chapters.created_at, NOW()), " ngày")
                                ELSE CONCAT(TIMESTAMPDIFF(MONTH, chapters.created_at, NOW()), " tháng")
                            END AS time_diff'),  DB::raw('CONCAT("https://magiabaiser.id.vn/", MIN(pages.image)) as image'))
                ->get(),
        ];
    }
}
