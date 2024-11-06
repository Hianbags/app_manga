@extends('layouts.app')

@section('content')
    <form id="update-order-form" action="{{ route('orders.update', ['id' => $order->id]) }}" method="POST">
        @csrf
        @method('PUT')
        <div class="form-group">
            <label for="status">Status:</label>
            <select class="form-control" id="status" name="status">
                <option value="pending">Pending</option>
                <option value="processing">Processing</option>
                <option value="completed">Completed</option>
                <option value="cancelled">Cancelled</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Update</button>
    </form>
@endsection
