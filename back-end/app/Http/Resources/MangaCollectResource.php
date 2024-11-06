<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Support\Facades\DB;

class MangaCollectResource extends ResourceCollection
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return $this->collection->transform(function ($manga) {
            $chapter = DB::table('chapters')
                ->select(
                    'title',
                    DB::raw('CASE 
                                WHEN TIMESTAMPDIFF(HOUR, created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(MINUTE, created_at, NOW()), " phút")
                                WHEN TIMESTAMPDIFF(DAY, created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(HOUR, created_at, NOW()), " giờ")
                                WHEN TIMESTAMPDIFF(MONTH, created_at, NOW()) < 1 THEN CONCAT(TIMESTAMPDIFF(DAY, created_at, NOW()), " ngày")
                                ELSE CONCAT(TIMESTAMPDIFF(MONTH, created_at, NOW()), " tháng")
                            END AS time_diff')
                )
                ->where('manga_id', $manga->id)
                ->latest()
                ->first();

            return [
                'id' => $manga->id,
                'image' => "https://magiabaiser.id.vn/{$manga->image}",
                'title' => $manga->title,
                'author' => $manga->author,
                'rating' => $manga->rating,
                'views' => $manga->views,
                'chapter' => $chapter,
            ];
        })->toArray();
    }

    public function withResponse($request, $response)
    {
        $response->setData(array_merge(
            $response->getData(true),
            ['meta' => [
                'total' => $this->resource->total(),
                'per_page' => $this->resource->perPage(),
                'current_page' => $this->resource->currentPage(),
                'last_page' => $this->resource->lastPage(),
                'from' => $this->resource->firstItem(),
                'to' => $this->resource->lastItem(),
            ]]
        ));
    }
}