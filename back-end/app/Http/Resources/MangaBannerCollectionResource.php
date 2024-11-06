<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class MangaBannerCollectionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'image' => "https://magiabaiser.id.vn/$this->image",
            'title' => $this->title,
            'description' => $this->description,
            'categories' => DB::table('manga_categories')
                                ->join('categories', 'manga_categories.category_id', '=', 'categories.id')
                                ->where('manga_categories.manga_id', $this->id)
                                ->select('categories.id' ,'categories.title')
                                ->get(),
            'rating' => $this->rating,
            'views' => $this->views,
        ];
    }
}
