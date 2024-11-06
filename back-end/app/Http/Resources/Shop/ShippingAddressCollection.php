<?php

namespace App\Http\Resources\Shop;

use Illuminate\Http\Resources\Json\ResourceCollection;

class ShippingAddressCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request): array
    {
        return [
            'data' => $this->collection->transform(function($shippingAddress) {
                return [
                    'id' => $shippingAddress->id,
                    'recipient_name' => $shippingAddress->recipient_name,
                    'phone_number' => $shippingAddress->phone_number,
                    'street_address' => $shippingAddress->street_address,
                    'province' => $shippingAddress->province,
                    'district' => $shippingAddress->district,
                    'ward' => $shippingAddress->ward,
                ];
            }),
        ];
    }
}

