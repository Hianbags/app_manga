<?php

namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Http\Resources\Shop\ShippingAddressCollection;
use App\Models\Shop\ShippingAddress;
use Illuminate\Http\Request;

class ShippingAddressController extends Controller
{
    public function index()
    {
        try {
            $addresses = ShippingAddress::where('user_id', auth()->id())->get();
            return new ShippingAddressCollection($addresses);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to get addresses!', 'error' => $e->getMessage()], 400);
        }
    }
    public function store(Request $request)
    {
        try {
        $this->validate($request, [
            'recipient_name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:15',
            'street_address' => 'required|string|max:255',
            'province' => 'required|string|max:255',
            'district' => 'required|string|max:255',
            'ward' => 'required|string|max:255',
        ]);
            $address = ShippingAddress::create([
            'recipient_name' => $request->recipient_name,
            'phone_number' => $request->phone_number,
            'street_address' => $request->street_address,
            'province' => $request->province,
            'district' => $request->district,
            'ward' => $request->ward,
            'user_id' => auth()->id()
        ]);
        return response()->json(['message' => 'Address saved successfully!'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to save address!', 'error' => $e->getMessage()], 400);
        }
    }
}
