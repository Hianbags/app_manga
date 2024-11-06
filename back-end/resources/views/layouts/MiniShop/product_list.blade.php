@extends('dashboard')
@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item active" aria-current="page"></li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Danh sách sản phẩm</h4>
                        <div id="loading" style="display: none;">Loading...</div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Mô tả</th>
                                        <th>Giá</th>
                                        <th>Danh mục</th>
                                        <th>Ngày tạo</th>
                                        <th>Ngày cập nhật</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="products-table-body">
                                </tbody>
                            </table>
                        </div>
                        <div id="error-message" style="color: red; display: none;">Không thể tải sản phẩm. Vui lòng thử lại sau.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        loadProducts();
    });

    function loadProducts() {
        document.getElementById('loading').style.display = 'block';
        document.getElementById('error-message').style.display = 'none';

        fetch('http://localhost:8000/api/product')
            .then(response => response.json())
            .then(data => {
                const productsTableBody = document.getElementById('products-table-body');
                productsTableBody.innerHTML = '';
                data.data.forEach(product => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${product.id}</td>
                        <td><img src="${product.image}" alt="product image" style="max-width: 100px;"></td>
                        <td>${product.name}</td>
                        <td>${truncateDescription(product.description)}</td>
                        <td>${product.price}</td>
                        <td>${formatCategories(product.category)}</td>
                        <td>${product.created_at}</td>
                        <td>${product.updated_at}</td>
                        <td>
                            <button onclick="showProduct(${product.id})">chi tiết</button>
                            <button onclick="deleteProduct(${product.id})">Xóa</button>
                        </td>
                    `;
                    productsTableBody.appendChild(row);
                });
                document.getElementById('loading').style.display = 'none';
            })
            .catch(error => {
                console.error('Error fetching products:', error);
                document.getElementById('error-message').style.display = 'block';
                document.getElementById('loading').style.display = 'none';
            });
    }

    function deleteProduct(productId) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?')) {
            fetch(`http://localhost:8000/api/product/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('Xóa sản phẩm thành công');
                    loadProducts();
                } else {
                    alert('Xóa sản phẩm thất bại');
                }
            })
            .catch(error => console.error('Error deleting product:', error));
        }
    }

    function showProduct(productId) {
        window.location.href = `show-product?product_id=${productId}`;
    }
    function truncateDescription(description, maxWords = 10) {
        if (!description) return '';
        const words = description.split(' ');
        if (words.length <= maxWords) {
            return description;
        } else {
            return words.slice(0, maxWords).join(' ') + '...';
        }
    }

    function formatCategories(categories) {
        return categories.map(category => category.title).join(', ');
    }
</script>
@endsection
