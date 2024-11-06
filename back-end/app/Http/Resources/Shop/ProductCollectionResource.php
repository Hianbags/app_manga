<?php

namespace App\Http\Resources\Shop;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class ProductCollectionResource extends JsonResource
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
            'image' => config('app.url') . '/' . DB::table('product_images')
            ->where('product_id', $this->id)->value('image_path'),
            'category' => DB::table('product_categories_items') // Lấy danh sách danh mục sản phẩm
                ->where('product_id', $this->id)
                ->join('product_categories', 'product_categories_items.product_category_id', '=', 'product_categories.id')
                ->select('product_categories.id','product_categories.title')->get(),
            'created_at' => Carbon::parse($this->created_at)->format('s:i:H d-m-Y'),
            'updated_at' => Carbon::parse($this->updated_at)->format('s:i:H d-m-Y'),
        ];
    }
}
