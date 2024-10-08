# VNPtt
Phát triển mới, BSC, Duy trì
#HDSD
 + pull (kéo về): lấy code của thằng làm chung đã push (đẩy) lên.
      Pull từ từ branch nào về branch hiện tại cũng được, nếu pull từ branch khác thì sẽ có "Merge" xảy ra,
          còn pull từ cũng branch thì là như update code base. 
      Khi mình làm thay đổi dưới local trùng với chỗ người nào đó đã sửa và push lên (nhưng mình chưa pull về trước đó),
          thì khi pull về sẽ có "conflict". 
      "Conflict" nghĩa là "đụng độ". Khi code pull về bị conflict, cần phải "Resolve conflict" bằng cách chọn thay đổi nào
         được giữ lại và thay đổi nào sẽ xóa đi hoặc giữ lại cả 2 và chỉnh sửa cho tụi nó hoạt động.
    + push (đẩy): đưa code lên remote repository, nghĩa là đẩy lên cho tụi kia kéo về
    + Collaborators: làm việc nhóm với git như nào:
      + ai tạo repos thì vào đây: https://github.com/<tên_tài_khoản>/<tên_repos>/settings/collaboration
