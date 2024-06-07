<template>
  <el-table :data="tableData" stripe border="true">
    <el-table-column type="selection" width="55"></el-table-column>
    <el-table-column prop="isbn" label="ISBN" sortable />
    <el-table-column prop="name" label="Title" />
    <el-table-column prop="price" label="Price" sortable/>
    <el-table-column prop="author" label="Author" />
    <el-table-column prop="publisher" label="Publisher" />
    <el-table-column prop="createTime" label="PublicationTime" sortable/>
  </el-table>
</template>

<script>
import axios from 'axios'

export default {
  created () {
    this.loadbook(9787532512112)
  },
  methods: {
    loadbook (isbn) {
      axios.get('https://apis.5share.site/books/?isbn=' + isbn).then(res => {
        console.log(res)
        const bookInfo={
          name:res.data.info.name,
          isbn:res.data.info.isbn_13,
          createTime:res.data.info.publishedDate,
          author:res.data.info.authors,
          publisher:res.data.info.publisher
        }
        this.tableData.push(bookInfo)
      })
    }
  },
  data () {
    return {
      tableData: []
    }
  }
}
</script>

<style scoped>

</style>
