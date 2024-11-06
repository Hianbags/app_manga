@extends('dashboard')
@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h3 class="page-title">Thêm Category</h3>
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thêm Category</li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form id="addCategoryForm">
                            @csrf
                            <div class="form-group">
                                <label for="title">Title:</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="description">Description:</label>
                                <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Thêm Category</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Danh sách Categories</h4>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody id="categoriesList">
                                    <!-- Categories will be appended here dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const addCategoryForm = document.getElementById('addCategoryForm');
        const categoriesList = document.getElementById('categoriesList');

        addCategoryForm.addEventListener('submit', function (event) {
            event.preventDefault();
            const formData = new FormData(addCategoryForm);
            fetch('/api/category', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('Category added successfully!');
                    appendCategory(data.data);
                    addCategoryForm.reset();
                } else {
                    alert('Failed to add category: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error adding category:', error);
                alert('Failed to add category. Please try again later.');
            });
        });

        function fetchCategories() {
            fetch('/api/category')
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        data.data.forEach(category => appendCategory(category));
                    } else {
                        alert('Failed to fetch categories: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error fetching categories:', error);
                    alert('Failed to fetch categories. Please try again later.');
                });
        }

        function appendCategory(category) {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${category.id}</td>
                <td>${category.title}</td>
                <td>${category.description}</td>
            `;
            categoriesList.appendChild(row);
        }

        fetchCategories();
    });
</script>

@endsection
