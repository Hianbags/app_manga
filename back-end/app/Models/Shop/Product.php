<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'description',
        'price',
    ];
    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }
        public function categories()
    {
        return $this->belongsToMany(Category::class, 'product_categories_items', 'product_id', 'product_category_id');
    }
}
