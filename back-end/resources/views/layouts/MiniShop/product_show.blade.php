@extends('dashboard')
@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h4 class="page-title">Chi tiết sản phẩm</h4>
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{{ route('productlist') }}">Danh sách sản phẩm</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chi tiết sản phẩm</li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title"></h4> <!-- Tên sản phẩm -->
                        <div class="row">
                            <div class="col-md-6">
                                <img src="" alt="" style="max-width: 100%;"> <!-- Ảnh sản phẩm -->
                            </div>
                            <div class="col-md-6">
                                <p><strong>Mô tả:</strong></p>
                                <p><strong>Giá:</strong></p>
                                <p><strong>Danh mục:</strong></p>
                                <p><strong>Ngày tạo:</strong></p>
                                <p><strong>Ngày cập nhật:</strong></p>
                            </div>
                        </div>
                        <!-- Nút Chỉnh sửa -->
                        <button onclick="redirectToEditPage({{ request()->get('product_id') }})" class="btn btn-warning mt-3">Chỉnh sửa</button>
                        <a href="{{ route('productlist') }}" class="btn btn-primary mt-3">Quay lại</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetchProductDetails();
    });

    const productId = {{ request()->get('product_id') }};

    function fetchProductDetails() {
        const apiUrl = '/api/show-product/' + productId;

        fetch(apiUrl)
            .then(response => response.json())
            .then(data => {
                displayProductDetails(data.data);
            })
            .catch(error => console.error('Error fetching data:', error));
    }

    function displayProductDetails(data) {
        document.querySelector('.card-title').innerText = data.name;
        document.querySelector('img').src = data.images[0];
        document.querySelector('img').alt = data.name;
        document.querySelector('p:nth-of-type(1) strong').innerText = 'Mô tả: ' + data.description;
        document.querySelector('p:nth-of-type(2) strong').innerText = 'Giá: ' + data.price + ' VND';

        const categories = data.category.map(cat => cat.title).join(', ');
        document.querySelector('p:nth-of-type(3) strong').innerText = 'Danh mục: ' + categories;

        document.querySelector('p:nth-of-type(4) strong').innerText = 'Ngày tạo: ' + data.created_at;
        document.querySelector('p:nth-of-type(5) strong').innerText = 'Ngày cập nhật: ' + data.updated_at;
    }

    function redirectToEditPage(productId) {
        const url = `edit-product?product_id=${productId}`;
        window.location.href = url;
    }
</script>
@endsection
