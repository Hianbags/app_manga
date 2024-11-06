<?php
namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class ProductImage extends Model
{
    protected $table = 'product_images';
    protected $fillable = ['product_id', 'image_path'];

   
}
