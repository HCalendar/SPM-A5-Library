<template>
  <div>
    <h1>Favorite Books</h1>
    <div v-if="favoriteBooks.length === 0">
      <p>No favorite books yet.</p>
    </div>
    <div v-else>
      <ul>
        <li v-for="book in favoriteBooks" :key="book.id">
          {{ book.title }} by {{ book.author }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FavoriteBooks',
  computed: {
    favoriteBooks() {
      return this.$store.state.favoriteBooks;
    }
  }
};
</script>

