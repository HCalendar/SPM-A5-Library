启动方式：
1.运行sql文件，创建数据库
2.检查libraryBack/src/main/resources/application.yml配置，是否连接到自己的数据库
3.运行libraryBack/src/main/java/LibraryBackApplication，启动后端
4.cd libraryFront，npm install（应该会很慢，慢慢等node_modules全部下载完），npm run serve，启动前端
5.点给的local或者通过http://localhost:8080访问也可以
