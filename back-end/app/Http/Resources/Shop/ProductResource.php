<?php

namespace App\Http\Resources\Shop;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class ProductResource extends JsonResource
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
            'name' => $this->name,
            'description' => $this->description,
            'price' => $this->price,
            'category' => DB::table('product_categories_items')
                ->where('product_id', $this->id)
                ->join('product_categories', 'product_categories_items.product_category_id', '=', 'product_categories.id')
                ->select('product_categories.id', 'product_categories.title')->get(),
            'images' => DB::table('product_images')->where('product_id', $this->id)->pluck('image_path')->map(function ($path) {
                return config('app.url') . '/' . $path;
            }),
            'created_at'=> $this->created_at->format('s:i:H d-m-Y'),
            'updated_at'=> $this->updated_at->format('s:i:H d-m-Y'),
        ];
    }
    
}
