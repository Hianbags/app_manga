<?php
namespace App\Http\Controllers\API_BackEnd\User;
use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Http\Resources\UserResource;
use App\Models\Avatar\Avatar;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
   
    public function login(){
        if (Auth::attempt(['email' => request('email'), 'password' => request('password')])) {
            /** @var \App\Models\User */
            $user = auth()->user();
            $success['token'] = $user->createToken('MyApp')->accessToken;
            $success['name'] = $user->name;
            return $this->sendResponse($success, 'User login successfully.');
        } else {
            return $this->sendError('Unauthorised', ['error' => 'Unauthorised'], 401);
        }
    }
    public function login_forum(){
        if (Auth::attempt(['email' => request('email'), 'password' => request('password')])) {
            /** @var \App\Models\User */
            $user = auth()->user();
            $success['token'] = $user->createToken('MyApp')->accessToken;
            $success['name'] = $user->name;
            return redirect()->away('http://localhost:8000/forum');
        } else {
            return $this->sendError('Unauthorised', ['error' => 'Unauthorised'], 401);
        }
    }
    public function register(Request $request ){
        $this->validate($request, [
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required',
            'c_password' => 'required|same:password',
        ]);
        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $susccess['token'] = $user->createToken('MyApp')->accessToken;
        $susccess['name'] = $user->name;
        return response()->json(['success' => $susccess], 200);
    }
    public function logout()
    {
        if (Auth::check()) {
            /** @var \App\Models\User */
            $user = Auth::user();
    
            // Thu hồi token hiện tại
            $accessToken = $user->token();
    
            if ($accessToken) {
                $accessToken->revoke();
            }
        }
    
        Auth::logout(); // Đăng xuất người dùng hiện tại
        return view('auth.login');
    }
    
    public function details(){
        try{
            $user = Auth::user();
            return $this->sendResponse(new UserResource($user), 'User Details');
        }catch(\Exception $e){
            return $this->sendError($e->getMessage(), [], 500);
        }
    }
    public function store(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        if ($request->hasFile('avatar')) {
            $avatarName = 'avatar_' . time() . '.' . $request->avatar->getClientOriginalExtension();
            $path = $request->avatar->storeAs('public/avatars', $avatarName);

            // Lưu đường dẫn đầy đủ vào cơ sở dữ liệu
            $avatar = new Avatar();
            $avatar->image = '/storage/avatars/' . $avatarName;
            $avatar->save();

            return response()->json(['message' => 'Avatar uploaded successfully.', 'avatar_id' => $avatar->id], 200);
        }
        return response()->json(['message' => 'No avatar uploaded.'], 400);
    }
    public function update(Request $request)
    {
        try {
            $request->validate([
                'avatar_id' => 'required|exists:avatars,id',
            ]);
    
            $user = Auth::user();
            DB::table('users_avatars')->updateOrInsert(
                ['user_id' => $user->id],
                ['avatar_id' => $request->avatar_id]
            );
            return response()->json(['message' => 'Avatar updated successfully.'], 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => 'Validation failed.', 'messages' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while updating avatar.'], 500);
        }
    }
    
    public function index()
    {
        // Lấy tất cả các đối tượng Avatar
        $avatars = Avatar::all(['id', 'image']);
        
        // Thêm domain vào trường image của mỗi đối tượng
        $avatars->transform(function($avatar) {
            $avatar->image = url($avatar->image); // Thêm domain vào đường dẫn hình ảnh
            return $avatar;
        });
    
        // Trả về kết quả dưới dạng JSON
        return response()->json(['avatars' => $avatars], 200);
    }
    
}