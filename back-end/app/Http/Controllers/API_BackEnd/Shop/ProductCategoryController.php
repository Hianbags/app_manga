<?php

namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Http\Resources\Shop\ProductCollectionResource;
use App\Models\Shop\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProductCategoryController extends Controller
{
     public function index()
    {
        // Retrieve the list of product categories and the count of products in each category
        $categories = DB::table('product_categories')
            ->leftJoin('product_categories_items', 'product_categories.id', '=', 'product_categories_items.product_category_id')
            ->leftJoin('products', 'product_categories_items.product_id', '=', 'products.id')
            ->select('product_categories.id', 'product_categories.title', DB::raw('COUNT(products.id) as product_count'))
            ->groupBy('product_categories.id', 'product_categories.title')
            ->get();
        
        return response()->json([
            'status' => 'success',
            'data' => $categories,
        ]);
    }
    public function show($id)
    {
        try {
            $product = DB::table('product_categories_items')
                ->where('product_category_id', $id)
                ->join('products', 'product_categories_items.product_id', '=', 'products.id')
                ->get();
            return response()->json([
                'status' => 'success',
                'data' => ProductCollectionResource::collection($product),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}