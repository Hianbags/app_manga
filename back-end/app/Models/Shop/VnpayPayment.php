<?php
namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VnpayPayment extends Model
{
    use HasFactory;

    protected $table = 'vnpay_payments';

    protected $fillable = [
        'vnp_Amount',
        'vnp_BankCode',
        'vnp_CardType',
        'vnp_OrderInfo',
        'vnp_TxnRef',
        'vnp_ResponseCode'
    ];
}
