<?php
namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\Shop\Order;
use App\Models\Shop\VnpayPayment;
use Faker\Provider\ar_EG\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PaymentController extends Controller
{
    public function vnpay_payment(Request $request)
    {
        $this->validate($request, [
            'amount' => 'required|numeric',
            'id_order' => 'required|integer',
        ]);
    
        $vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
        $vnp_Returnurl = "http://localhost:8000/api/vnpay_callback"; // Cập nhật thành URL chính xác của bạn
        $vnp_TmnCode = "EPCM7LL3";
        $vnp_HashSecret = "9AU2QK462GAVO56EJBXA3TQ1DP469G44";
        $vnp_TxnRef = $request->id_order;
        $vnp_OrderInfo = "Thanh toán hóa đơn cho đơn hàng số " . $vnp_TxnRef;
        $vnp_OrderType = "billpayment";
        $vnp_Amount = $request->amount * 100;
        $vnp_Locale = "VN";
        $vnp_BankCode = "NCB";
        $vnp_IpAddr = $_SERVER['REMOTE_ADDR'];
    
        $inputData = [
            "vnp_Version" => "2.1.0",
            "vnp_TmnCode" => $vnp_TmnCode,
            "vnp_Amount" => $vnp_Amount,
            "vnp_Command" => "pay",
            "vnp_CreateDate" => date('YmdHis'),
            "vnp_CurrCode" => "VND",
            "vnp_IpAddr" => $vnp_IpAddr,
            "vnp_Locale" => $vnp_Locale,
            "vnp_OrderInfo" => $vnp_OrderInfo,
            "vnp_OrderType" => $vnp_OrderType,
            "vnp_ReturnUrl" => $vnp_Returnurl,
            "vnp_TxnRef" => $vnp_TxnRef,
        ];
        if (isset($vnp_BankCode) && $vnp_BankCode != "") {
            $inputData['vnp_BankCode'] = $vnp_BankCode;
        }
        if (isset($vnp_Bill_State) && $vnp_Bill_State != "") {
            $inputData['vnp_Bill_State'] = $vnp_Bill_State;
        }
    
        ksort($inputData);
        $query = "";
        $i = 0;
        $hashdata = "";
        foreach ($inputData as $key => $value) {
            if ($i == 1) {
                $hashdata .= '&' . urlencode($key) . "=" . urlencode($value);
            } else {
                $hashdata .= urlencode($key) . "=" . urlencode($value);
                $i = 1;
            }
            $query .= urlencode($key) . "=" . urlencode($value) . '&';
        }
        $vnp_Url = $vnp_Url . "?" . $query;
        if (isset($vnp_HashSecret)) {
            $vnpSecureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);
            $vnp_Url .= 'vnp_SecureHash=' . $vnpSecureHash;
        }
        $returnData = [
            'code' => '01',
            'message' => 'success',
            'data' => $vnp_Url
        ];
        return response()->json($returnData);
    }
    public function vnpay_callback(Request $request)
    {
    $vnp_HashSecret = "9AU2QK462GAVO56EJBXA3TQ1DP469G44";
    $inputData = $request->all();
    $vnp_SecureHash = $inputData['vnp_SecureHash'];
    unset($inputData['vnp_SecureHash']);
    ksort($inputData);
    $hashData = "";
    foreach ($inputData as $key => $value) {
        $hashData .= urlencode($key) . '=' . urlencode($value) . '&';
    }
    $hashData = trim($hashData, '&');
    $secureHash = hash_hmac('sha512', $hashData, $vnp_HashSecret);
    if ($secureHash === $vnp_SecureHash) {
        if ($inputData['vnp_ResponseCode'] == '00') {
            DB::beginTransaction();
            try {
                Order::where('id', $inputData['vnp_TxnRef'])->update([
                    'is_paid' => 1
                ]);
                VnpayPayment::create($inputData);
                DB::commit();
                return;
            } catch (\Exception $e) {
                DB::rollBack();
                return response()->json(['code' => '00', 'message' => 'Failed to update order', 'data' => $e->getMessage()]);
            }
        } else {
            return response()->json(['code' => '00', 'message' => 'Payment failed']);
        }
    } else {
        return response()->json(['code' => '00', 'message' => 'Invalid signature']);
    }
}

}
