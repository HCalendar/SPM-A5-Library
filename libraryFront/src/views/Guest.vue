<template>
  <div>
    <el-container>
      <el-header>
        <div class="content-container">
          <div class="center-text">LMS-Only Search for Books</div>
          <el-button type="text" class="right-button" @click="$router.push('/register')">Register to use all functions</el-button>
          <el-button type="text" @click="$router.push('/login')">Return</el-button>
        </div>
      </el-header>
      <el-main>
        <!-- 搜索-->
        <div style="margin: 10px 0;">
          <el-form inline="true" size="small">
            <el-form-item label="ISBN" >
              <el-input v-model="search1" placeholder="Please enter ISBN"  clearable>
              </el-input>
            </el-form-item >
            <el-form-item label="Title" >
              <el-input v-model="search2" placeholder="Please enter title"  clearable>
              </el-input>
            </el-form-item >
            <el-form-item label="Author" >
              <el-input v-model="search3" placeholder="Please enter author"  clearable>
              </el-input>
            </el-form-item >
            <el-form-item>
              <el-button type="primary" style="margin-left: 1%" @click="load" size="mini" >
                Search</el-button>
            </el-form-item>
            <el-form-item>
              <el-button size="mini"  type="danger" @click="clear">Reset</el-button>
            </el-form-item>
          </el-form>
        </div>
        <div>
          <el-table :data="tableData" stripe border="true" @selection-change="handleSelectionChange">
            <el-table-column prop="isbn" label="ISBN" sortable />
            <el-table-column prop="name" label="Title" />
            <el-table-column prop="author" label="Author" />
            <el-table-column prop="publisher" label="Publisher" />
            <el-table-column prop="createTime" label="Publication Time" sortable/>
          </el-table>
        </div>
        <!--    分页-->
        <div class="block">
          <el-pagination
              v-model:currentPage="currentPage"
              :page-sizes="[5, 10, 20]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange">
          </el-pagination>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script>

import request from "../utils/request";

export default {
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.load()
  },
  data(){
    return {
      currentPage: 1,
      pageSize: 10,
      total: 100,
      search1:'',
      search2:'',
      search3:'',
      tableData: [],
      numOfOutDataBook: 0,
      outDateBook:[],
    }
  },
  name: 'LGuest',
  methods: {
    // (this.isbnArray.indexOf(scope.row.isbn)) == -1
    handleSelectionChange(val){
      this.ids = val.map(v =>v.id)
    },
    async load(){
      try{
        this.numOfOutDataBook =0;
        this.outDateBook =[];
        request.get("http://localhost:8181/book/All",{
          params:{
            pageNum: this.currentPage,
            pageSize: this.pageSize,
            search1: this.search1,
            search2: this.search2,
            search3: this.search3,
          }
        }).then(res =>{
          console.log(res)
          this.tableData = res.data.records;
          this.total = res.data.total
        })
      }catch (error) {
        console.error('Error guest:', error);
      }
    },
    clear(){
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
    },
    handleSizeChange(pageSize){
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum){
      this.pageNum = pageNum
      this.load()
    }
  }
}
</script>

<style scoped>
.content-container {
  display: flex;
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中，但是这里的中心指的是内容容器本身的中心，而不是页面中心 */
}
.center-text {
  flex-shrink: 0;
  margin-right: 10px;
  line-height:1.7;
  font-size:50px;
  font-weight: bold;
}
.right-button{
  margin-left: auto;
}
</style>
