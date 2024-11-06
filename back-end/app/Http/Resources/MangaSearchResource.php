<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class MangaSearchResource extends JsonResource
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
            'chapters' => DB::table('chapters')->where('manga_id', $this->id)->
                select('title')
                ->latest()
                ->first(),
        ];
    }
}
