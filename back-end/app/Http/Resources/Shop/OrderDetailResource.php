<?php

namespace App\Http\Resources\Shop;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class OrderDetailResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $domain = 'https://magiabaiser.id.vn/';
        return [
            'id' => $this->id,
            'shipping_address' => DB::table('shipping_addresses')
            ->where('id', $this->shipping_address_id)->select('id', 'recipient_name', 'street_address', 'phone_number'
            , 'province', 'district', 'ward')
            ->first(),
            'product' => $this->products->map(function($product) use ($domain) {
                $productImage = DB::table('product_images')->where('product_id', $product->id)->first();
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'price' => $product->price,
                    'quantity' => DB::table('order_products')->where('order_id', $this->id)->where('product_id', $product->id)->count(),
                    'image_path' => $productImage ? $domain . '/' . $productImage->image_path : null,
                ];
            }),
            'status' => $this->status,
            'total_price' => $this->total_price,
            'created_at'=> $this->created_at->format('s:i:H d-m-Y'),
            'updated_at'=> $this->updated_at->format('s:i:H d-m-Y'),
        ];
        
    }
}