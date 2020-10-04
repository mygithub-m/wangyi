
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

public class DownLoadTest {

    /**
     * 文件下载
     *
     * @param path 下载保存路径
     * @Param url 网络路径
     */
    public static void download(String url, String path) {
        //获取字节输入、输出流
        FileOutputStream output = null;
        InputStream input = null;
        //处理传进来的url路径,包括中文字符，空格等的处理
        File modifyPath = new File(url);
        String fileName = modifyPath.getName(); //获取文件名


        try {
            fileName = URLEncoder.encode(fileName,"utf-8").replace("+","%20"); //处理中文字符，以及空格
            URL urls = new URL("http://localhost:8080/music_player_remote_song/"+fileName);
            //获取HttpURLConnection对象，获取网络文件的信息
            HttpURLConnection httpURLConnection = (HttpURLConnection) urls.openConnection();
            //获取文件大小
            long length = httpURLConnection.getContentLengthLong();

            //获取file文件对象
            File file = new File(path);
            if (!file.getParentFile().exists()) { //如果文件目录不存在,创建
                file.getParentFile().mkdirs();
            }
            if (file.exists()) {  //如果文件已经存在了，删除文件
                file.delete();
            }
            file.createNewFile();  //创建文件

            input = httpURLConnection.getInputStream();  //获取文件字节输入流
            output = new FileOutputStream(file);  //文件输出流

            //将文件分成100份,每一份为unit
            long unit = length / 100;
            //下载进度记录,默认为0
            long progress = 0;
            //记录现在下载了百分之几
            long now = 0;
            //保存在线下载了百分之几
            long saveNow = 0;


            //定义缓冲数组
            byte[] bytes = new byte[1];
            int len = 0;
            System.out.println("开始下载！....");
            //文件写入
            while ((len = input.read(bytes)) != -1){
                output.write(bytes,0,len);
                progress += len;
                now = progress / unit;  //
                //判断下载进度
                if (now >= 1 && now > saveNow){ //说明下载呈现百分比变化
                    saveNow =now; //跟新已经下载的百分数
                    System.out.println("下载了"+saveNow+"%");
                }
            }
            System.out.println("下载成功！");


        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            //关闭流
            if (output != null){
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (input != null){
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    public static void main(String[] args) {
        String url = "http://localhost:8080/music_player_remote_song/许嵩 - 断桥残雪.mp3";
        String path = "C:\\Users\\3031874211\\Desktop\\downloadTest\\test\\断桥残雪.mp3";
        download(url, path);
    }
}
