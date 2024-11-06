@extends('dashboard')

@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h3 class="page-title">Create Manga</h3>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Manga</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Create</li>
                </ol>
            </nav>
        </div>
        <div class="row">
            <div class="col-lg-8 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form class="forms-sample" id="create-manga-form" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="image">Image</label>
                                <input type="file" class="form-control-file" id="image" name="image" required>
                            </div>
                            <div class="form-group">
                                <label for="title">Title</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="author">Author</label>
                                <input type="text" class="form-control" id="author" name="author" required>
                            </div>
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="status">Status</label>
                                <select class="form-control" id="status" name="status" required>
                                    <option value="completed">Completed</option>
                                    <option value="ongoing">Ongoing</option>
                                    <option value="dropped">Dropped</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="categories">Categories</label>
                                <select class="form-control" id="categories" name="category_ids[]" multiple required>
                                    <!-- Populate categories dynamically using JavaScript or fetch them from another API -->
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="selected-categories">Selected Categories</label>
                                <div id="selected-categories" class="selected-categories">
                                    <!-- Selected categories will be added here dynamically -->
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary mr-2">Submit</button>
                            <button class="btn btn-light">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        fetchCategories();
        
        const form = document.getElementById('create-manga-form');
        form.addEventListener('submit', function (event) {
            event.preventDefault();
            const formData = new FormData(this);
            
            const selectedCategoryInputs = document.querySelectorAll('.selected-category input[name="selected_category_ids[]"]');
            
            // Clear existing category_ids[] inputs
            formData.delete('category_ids[]');
            
            // Add category_ids[] based on selected categories
            selectedCategoryInputs.forEach(input => {
                formData.append('category_ids[]', input.value);
            });
            
            createManga(formData);
        });

        const categoriesSelect = document.getElementById('categories');
        const selectedCategoriesContainer = document.getElementById('selected-categories');

        categoriesSelect.addEventListener('dblclick', function (event) {
            const selectedOption = event.target;
            if (selectedOption.tagName === 'OPTION') {
                addCategoryToList(selectedOption);
            }
        });

        selectedCategoriesContainer.addEventListener('click', function(event) {
            if(event.target.classList.contains('delete-category')) {
                event.target.parentElement.remove();
            }
        });
    });

    function fetchCategories() {
        fetch('https://magiabaiser.id.vn/api/category')
        .then(response => response.json())
        .then(data => {
            const categoriesSelect = document.getElementById('categories');
            categoriesSelect.innerHTML = ''; // Clear previous options
            
            data.data.forEach(category => {
                const option = document.createElement('option');
                option.value = category.id;
                option.textContent = category.title;
                categoriesSelect.appendChild(option);
            });
        })
        .catch(error => console.error('Error fetching categories:', error));
    }

    function createManga(formData) {
        fetch('https://magiabaiser.id.vn/api/manga', {
            method: 'POST',
            body: formData,
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert('Manga created successfully');
                // Optionally, redirect to another page
                // window.location.href = '/manga/' + data.manga.id;
            } else {
                alert('Failed to create manga: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error creating manga:', error);
            alert('Failed to create manga');
        });
    }

    function addCategoryToList(selectedOption) {
        const selectedCategoriesContainer = document.getElementById('selected-categories');
        const categoryItem = document.createElement('div');
        categoryItem.className = 'selected-category';
        categoryItem.innerHTML = `
            <span>${selectedOption.textContent}</span>
            <input type="hidden" name="selected_category_ids[]" value="${selectedOption.value}">
            <button type="button" class="delete-category btn btn-danger btn-sm">X</button>
        `;
        selectedCategoriesContainer.appendChild(categoryItem);
    }
</script>

@endsection
