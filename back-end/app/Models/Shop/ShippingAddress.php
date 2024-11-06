<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ShippingAddress extends Model
{
    use HasFactory;

    protected $fillable = [
        'recipient_name',
        'phone_number',
        'street_address',
        'province',
        'district',
        'ward',
        'user_id'
    ];
}
