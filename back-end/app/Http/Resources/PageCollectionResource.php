<?php

namespace App\Http\Resources;

use App\Models\Manga\Manga;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class PageCollectionResource extends JsonResource
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'image' =>"https://magiabaiser.id.vn$this->image",
        ];
    }
}
