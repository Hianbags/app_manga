<?php

namespace App\Models\Shop;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $table = 'product_categories';
    protected $fillable = [
        'title',
        'description',
    ];


}