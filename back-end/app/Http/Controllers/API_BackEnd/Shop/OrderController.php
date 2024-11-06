<?php

namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Http\Resources\Shop\OrderResource;
use App\Models\Shop\Order;
use App\Models\Shop\Product;
use App\Models\Shop\ShippingAddress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Resources\Shop\OrderCollectionResource;
use App\Http\Resources\Shop\OrderDetailResource;


class OrderController extends Controller
{
    public function order()
    {
        try{
        $orders = Order::all();
        return response()->json([
            'status' => 'success',
            'data' => OrderCollectionResource::collection($orders),
        ]);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
   //cập nhật tranm trạng thái đơn hàng
    public function update(Request $request, $id)
    {
        $this->validate($request, [
            'status' => 'required|in:pending,processing,completed,cancelled',
        ]);
        try{
            $order = Order::findOrFail($id);
        if (empty($order)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Order not found',
            ], 404);
        }
        $order->update($request->all());
        return response()->json([
            'status' => 'success',
            'data' => new OrderResource($order),
        ]);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function index()
    {
        try {
            $input = request()->all();
            $ordersQuery = Order::where('user_id', auth()->user()->id);

            if (isset($input['status'])) {
                $ordersQuery->where('status', $input['status']);
            }
            $orders = $ordersQuery->get();

            return response()->json([
                'status' => 'success',
                'data' => OrderResource::collection($orders),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }


    
  public function show($id)
    {
        try{
            $order = Order::findOrFail($id);
        if (empty($order)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Order not found',
            ], 404);
        }
        return response()->json([
            'status' => 'success',
            'data' => new OrderDetailResource($order),
        ]);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function store(Request $request)
    {
        $this->validate($request, [
            'shipping_address' => 'required|exists:shipping_addresses,id',
            'product_ids' => 'required|array',
            'product_ids.*' => 'exists:products,id'
        ]);

        try {
            DB::beginTransaction();
            // Calculate the total price
            $total_price = 0;
            foreach ($request->product_ids as $product_id) {
                $product = Product::find($product_id);
                $total_price += $product->price;
            }
            // Create the order
            $order = Order::create([
                'user_id' => auth()->user()->id,
                'total_price' => $total_price,
                'status' => 'pending'
            ]);
            // Attach products to the order
            $order->products()->attach($request->product_ids);
            $order->shipping_address_id = $request->shipping_address;
            $order->save();
            DB::commit();

            return response()->json(['data' => $order, 'status' => 'success'], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
}