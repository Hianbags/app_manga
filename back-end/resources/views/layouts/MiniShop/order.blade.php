@extends('dashboard')
@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="row">
            <div class="col-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Danh sách đơn hàng</h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Người dùng</th>
                                        <th>Tổng giá</th>
                                        <th>Sản phẩm</th>
                                        <th>Trạng thái</th>
                                        <th>Phương thức thanh toán</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="orders-table-body">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal for updating order status -->
<div class="modal fade" id="updateOrderModal" tabindex="-1" role="dialog" aria-labelledby="updateOrderModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateOrderModalLabel">Cập nhật đơn hàng</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="orderId">ID đơn hàng:</label>
                    <input type="text" class="form-control" id="orderId" readonly>
                </div>
                <div class="form-group">
                    <label for="orderUser">Người dùng:</label>
                    <input type="text" class="form-control" id="orderUser" readonly>
                </div>
                <div class="form-group">
                    <label for="orderTotalPrice">Tổng giá:</label>
                    <input type="text" class="form-control" id="orderTotalPrice" readonly>
                </div>
                <div class="form-group">
                    <label for="orderProducts">Sản phẩm:</label>
                    <textarea class="form-control" id="orderProducts" rows="3" readonly></textarea>
                </div>
                <div class="form-group">
                    <label for="orderPaymentMethod">Phương thức thanh toán:</label>
                    <textarea class="form-control" id="orderPaymentMethod" rows="3" readonly></textarea>
                </div>
                <div class="form-group">
                    <label for="statusSelect">Trạng thái mới:</label>
                    <select class="form-control" id="statusSelect">
                        <option value="pending">Đang chờ</option>
                        <option value="processing">Đang xử lý</option>
                        <option value="completed">Hoàn thành</option>
                        <option value="cancelled">Hủy bỏ</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="updateOrderStatus()">Lưu thay đổi</button>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        loadOrders();
    });

    function loadOrders() {
    fetch('/api/listorder') 
    .then(response => response.json())
    .then(data => {
        const ordersTableBody = document.getElementById('orders-table-body');
        ordersTableBody.innerHTML = ''; 
        data.data.forEach(order => {
            const products = order.products.map(product => product.name).join(', ');
            const shortProducts = products.length > 30 ? products.substring(0, 30) + '...' : products; // Hiển thị tối đa 30 ký tự

            // Kiểm tra xem phương thức thanh toán có rỗng không
            let paymentMethod;
            if (order.payment_method && order.payment_method.length > 0) {
                paymentMethod = order.payment_method.map(method => `
                    ID: ${method.id}<br>
                    Số tiền: ${method.vnp_Amount / 100} VND<br>
                    Loại thẻ: ${method.vnp_CardType}<br>
                    Mã ngân hàng: ${method.vnp_BankCode}<br>
                    Thông tin đơn hàng: ${method.vnp_OrderInfo}<br>
                    Mã giao dịch: ${method.vnp_TxnRef}<br>
                    Ngày tạo: ${method.created_at}<br>
                    Mã phản hồi: ${method.vnp_ResponseCode}
                `).join('<br><hr><br>');
            } else {
                paymentMethod = 'Thanh toán khi nhận hàng';
            }

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${order.id}</td>
                <td>${order.user}</td>
                <td>${order.total_price}</td>
                <td title="${products}">${shortProducts}</td> <!-- Hiển thị đoạn ngắn với toàn bộ chuỗi trong tooltip -->
                <td>${order.status}</td>
                <td>${paymentMethod}</td>
                <td>${order.created_at}</td>
                <td><button class="btn btn-primary" onclick="openUpdateOrderModal(${order.id},'${order.user}',${order.total_price},'${products}', \`${paymentMethod}\`)">Cập nhật</button></td>
            `;
            ordersTableBody.appendChild(row);
        });
    })
    .catch(error => console.error('Error fetching orders:', error));
}
    function openUpdateOrderModal(orderId, user, totalPrice, products, paymentMethod) {
        document.getElementById('orderId').value = orderId;
        document.getElementById('orderUser').value = user;
        document.getElementById('orderTotalPrice').value = totalPrice;
        document.getElementById('orderProducts').value = products;
        document.getElementById('orderPaymentMethod').value = paymentMethod;
        $('#updateOrderModal').modal('show');
    }

    function updateOrderStatus() {
        const orderId = document.getElementById('orderId').value;
        const newStatus = document.getElementById('statusSelect').value;
        fetch(`/api/order/${orderId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': '{{ csrf_token() }}'
            },
            body: JSON.stringify({ status: newStatus })
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert('Trạng thái đơn hàng đã được cập nhật thành công!');
                $('#updateOrderModal').modal('hide');
                loadOrders(); 
            } else {
                alert('Có lỗi xảy ra khi cập nhật đơn hàng: ' + data.message);
            }
        })
        .catch(error => console.error('Error updating order:', error));
    }
</script>

@endsection
