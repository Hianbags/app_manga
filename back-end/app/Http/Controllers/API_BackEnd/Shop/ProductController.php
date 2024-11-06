<?php

namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Http\Resources\Shop\ProductCollectionResource;
use App\Http\Resources\Shop\ProductResource;
use App\Models\Shop\Product;
use App\Models\Shop\ProductImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProductController extends Controller
{
    
public function getProductsByCategoryIds(Request $request)
{
    // Validate the incoming request
    $request->validate([
        'category_ids' => 'required|array',
        'category_ids.*' => 'integer',
    ]);
    // Get the category IDs from the request
    $categoryIds = $request->input('category_ids');

    // Retrieve the products based on the category IDs
    $products = Product::whereHas('categories', function($query) use ($categoryIds) {
        $query->whereIn('product_categories.id', $categoryIds);
    })->get();
    // Return the products as a JSON response
    return response()->json( ['data' => ProductCollectionResource::collection($products)], 200);
} 
    public function index()
    {
       $product =  Product::all();
       return response()->json(['data'=> ProductCollectionResource::collection($product)],200);
    }
    //show product
    public function show($id)
    {
        $product = Product::find($id);
        if ($product) {
            return response()->json(['data' => new ProductResource($product)], 200);
        } else {
            return response()->json(['message' => 'Product not found'], 404);
        }
    }
    public function show_admin($id)
    {
        $product = Product::find($id);
        if ($product) {
            return response()->json(['data' => new ProductResource($product)], 200);
        } else {
            return response()->json(['message' => 'Product not found'], 404);
        }
    }
    public function update(Request $request, $id)
{
    $this->validate($request, [
        'name' => 'required|string',
        'description' => 'required|string',
        'price' => 'required|numeric',
        'images.*' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
    ]);

    try {
        // Tìm sản phẩm theo ID
        $product = Product::findOrFail($id);

        // Cập nhật thông tin sản phẩm
        $product->update([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
        ]);

        // Mảng lưu đường dẫn hình ảnh
        $imagePaths = [];

        // Nếu có hình ảnh, xử lý và lưu chúng
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $imageName = time() . '_' . $image->getClientOriginalName();
                $image->move(public_path('images/product'), $imageName);
                $imagePath = 'images/product/' . $imageName;

                // Lưu đường dẫn hình ảnh vào mảng
                $imagePaths[] = $imagePath;

                // Tạo bản ghi hình ảnh sản phẩm mới
                $productImage = new ProductImage();
                $productImage->image_path = $imagePath;
                $productImage->product_id = $product->id;
                $productImage->save();
            }
        }

        // Chèn hình ảnh vào mô tả dựa trên ký hiệu [image]
        $description = $request->description;
        foreach ($imagePaths as $imagePath) {
            $imageTag = '<img src="' . asset($imagePath) . '" alt="Hình ảnh sản phẩm">';
            $description = preg_replace('/\[image\]/', $imageTag, $description, 1);
        }

        // Cập nhật mô tả sản phẩm
        $product->description = $description;
        $product->save();

        return response()->json(['data' => $product], 200);
    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}
//delete product
    public function destroy($id)
    {
        try {
            $product = Product::findOrFail($id);
            if ($product) {
                $product->delete();
                return response()->json(['message' => 'Product deleted successfully'], 200);
            } else {
                return response()->json(['message' => 'Product not found'], 404);
            }
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
    public function store(Request $request)
{
    $this->validate($request, [
        'name' => 'required|string',
        'description' => 'required|string',
        'price' => 'required|numeric',
        'images.*' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        'quantity' => 'required|integer',
    ]);
    try {
        $product = Product::create([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'quantity' => $request->quantity,
        ]);

        // Mảng lưu đường dẫn hình ảnh
        $imagePaths = [];

        // Nếu có hình ảnh, xử lý và lưu chúng
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $imageName = time() . '_' . $image->getClientOriginalName();
                $image->move(public_path('images/product'), $imageName);
                $imagePath = 'images/product/' . $imageName;

                // Lưu đường dẫn hình ảnh vào mảng
                $imagePaths[] = $imagePath;

                // Tạo bản ghi hình ảnh sản phẩm mới
                $productImage = new ProductImage();
                $productImage->image_path = $imagePath;
                $productImage->product_id = $product->id;
                $productImage->save();
            }
        }

        // Chèn hình ảnh vào mô tả dựa trên ký hiệu [image]
        $description = $request->description;
        foreach ($imagePaths as $imagePath) {
            $imageTag = '<img src="' . asset($imagePath) . '" alt="Hình ảnh sản phẩm">';
            $description = preg_replace('/\[image\]/', $imageTag, $description, 1);
        }

        // Cập nhật mô tả sản phẩm
        $product->description = $description;
        $product->save();

        return response()->json(['data' => $product], 200);
    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}
}
