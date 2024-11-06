@extends('dashboard')

@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h3 class="page-title">Edit Manga</h3>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Manga</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit</li>
                </ol>
            </nav>
        </div>
        <div class="row">
            <div class="col-lg-8 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form class="forms-sample" id="edit-manga-form" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="image">Image</label>
                                <input type="file" class="form-control-file" id="image" name="image">
                                <img id="current-image" src="" alt="Current image" style="max-width: 100px; margin-top: 10px;">
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
                                    <!-- Populate categories dynamically using JavaScript -->
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
        const mangaId = {{ request()->get('manga_id') }};
        fetchMangaDetails(mangaId);
        fetchCategories();

        const form = document.getElementById('edit-manga-form');
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
            
            updateManga(mangaId, formData);
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

    function fetchMangaDetails(mangaId) {
        fetch(`/api/manga/${mangaId}`)
            .then(response => response.json())
            .then(data => {
                const manga = data.data;
                document.getElementById('title').value = manga.title;
                document.getElementById('author').value = manga.author;
                document.getElementById('description').value = manga.description;
                document.getElementById('status').value = manga.status;
                document.getElementById('current-image').src = manga.image;
                populateSelectedCategories(manga.categories);
            })
            .catch(error => console.error('Error fetching manga details:', error));
    }

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

    function updateManga(mangaId, formData) {
        fetch(`/api/manga/${mangaId}`, {
            method: 'POST',
            body: formData,
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert('Manga updated successfully');
                // Optionally, redirect to another page
                // window.location.href = '/manga/' + mangaId;
            } else {
                alert('Failed to update manga: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error updating manga:', error);
            alert('Failed to update manga');
        });
    }

    function populateSelectedCategories(categories) {
        const selectedCategoriesContainer = document.getElementById('selected-categories');
        selectedCategoriesContainer.innerHTML = '';
        categories.forEach(category => {
            const categoryItem = document.createElement('div');
            categoryItem.className = 'selected-category';
            categoryItem.innerHTML = `
                <span>${category.title}</span>
                <input type="hidden" name="selected_category_ids[]" value="${category.id}">
                <button type="button" class="delete-category btn btn-danger btn-sm">X</button>
            `;
            selectedCategoriesContainer.appendChild(categoryItem);
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
