<?php

namespace App\Http\Controllers;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FirebaseService
{
    protected $messaging;

    public function __construct()
    {
        $serviceAccountPath = config('firebase.credentials');

        // Kiểm tra nếu đường dẫn không hợp lệ
        if (!$serviceAccountPath || !file_exists($serviceAccountPath)) {
            throw new \Exception('Invalid Firebase credentials path');
        }

        $factory = (new Factory)->withServiceAccount($serviceAccountPath);
        $this->messaging = $factory->createMessaging();
    }

public function sendNotification($token, $title, $body, $data = [])
{
    // Chuyển đổi dữ liệu thành chuỗi JSON nếu cần thiết
    $formattedData = [];
    foreach ($data as $key => $value) {
        if (is_array($value)) {
            $formattedData[$key] = json_encode($value);
        } else {
            $formattedData[$key] = (string) $value;
        }
    }

    $message = CloudMessage::withTarget('token', $token)
        ->withNotification(Notification::create($title, $body))
        ->withData($formattedData);

    $this->messaging->send($message);
}

}
