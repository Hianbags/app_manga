<?php

namespace App\Http\Resources\Shop;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class OrderCollectionResource extends JsonResource
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
            'user' => DB::table('users')->where('id', $this->user_id)->pluck('name')->first(),
            'total_price' => $this->total_price,
            'products' => DB::table('order_products')
                    ->where('order_id', $this->id)
                    ->join('products', 'order_products.product_id', '=', 'products.id')
                    ->select('products.id', 'products.name', 'products.price')
                    ->get(),
            'status' => $this->status,
            'is_paid' => $this->is_paid,
            'payment_method' => DB::table('vnpay_payments')->where('vnp_TxnRef', $this->id)->get(),
            'created_at'=> $this->created_at->format('s:i:H d-m-Y'),
            'updated_at'=> $this->updated_at->format('s:i:H d-m-Y'),
        ];
    }
}
