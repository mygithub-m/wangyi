package cn.learn.controller;

import cn.learn.pojo.DownLoad;
import cn.learn.pojo.Song;
import cn.learn.service.DownLoadService;
import cn.learn.service.SongService;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.*;
import java.util.*;

/**
 * 音乐下载controller
 */
@Controller
@RequestMapping("/download")
public class DownLoadController {

    @Autowired
    private SongService songService;

    @Autowired
    private DownLoadService downLoadService;

    //定义字节输入输出流
    private OutputStream output = null;
    private InputStream input = null;
    //控制音乐下载
    private boolean flag = false;


    /**
     * 用于用户搜索自己已经下载的歌曲
     * @param keyword
     * @return
     */
    @GetMapping("/search/{keyword}")
    @ResponseBody
    public List<DownLoad> searchLoad(@PathVariable(name = "keyword") String keyword,int uid){
        //查询用户下载的所有歌曲
        List<DownLoad> downLoads = downLoadService.findLoaded(uid);
        //存储满足条件的歌曲
        List<DownLoad> downLoadList = new ArrayList<DownLoad>();
        for (DownLoad downLoad : downLoads) {
            //通过歌曲名以及歌手名查询
            if (downLoad.getSong().getS_name().indexOf(keyword) != -1 || downLoad.getSong().getSinger().getSinger_name().indexOf(keyword) != -1){
                downLoadList.add(downLoad);
            }
        }
        return downLoadList;
    }

    /**
     * 清空用户正在下载的音乐列表
     * @param uid
     */
    @PostMapping("/clear")
    @ResponseBody
    public void clear(int uid){
        downLoadService.clearUser(uid);
    }

    /**
     * 暂停下载
     */
    @PostMapping("/pause")
    @ResponseBody
    public void pauseLoad(){
        if (output!=null){
            try {
                output.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        if (input!=null){
            try {
                input.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        flag = true;
    }


    /**
     * 获取用户还没下载啊得歌曲列表
     *
     * @param uid
     * @return
     */
    @GetMapping("/loading")
    @ResponseBody
    public List<DownLoad> getLoading(int uid) {
        return downLoadService.findLoading(uid);
    }


    /**
     * 获取用户已经下载得歌曲列表
     *
     * @param uid
     * @return
     */
    @GetMapping("/loaded")
    @ResponseBody
    public List<DownLoad> getLoaded(Integer uid) {
        if (uid != null){
            return downLoadService.findLoaded(uid);
        }
        return null;
    }

    /**
     * 将要下载的歌曲添加到下载列表中
     *
     * @param sid
     * @param uid
     */
    @PostMapping("/add")
    @ResponseBody
    public void addSongs(@RequestParam("sid[]") int[] sid, int uid) {
        for (int id : sid) {
            //先判断歌曲是否已经被下载了
            Integer res = downLoadService.isDownload(uid, id);
            if (res == null){  //为被下载
                //将每一首歌曲都封装为个downLoad对象
                DownLoad downLoad = new DownLoad();
                downLoad.setS_id(id);
                downLoad.setU_id(uid);
                //设置歌曲下载时间，为当前系统时间
                downLoad.setM_date(new Date());
                //设置歌曲状态，默认为未下载
                downLoad.setStatus(0L);
                //调用service方法添加再下载列表中
                downLoadService.addSong(downLoad);
            }
        }
    }

    /**
     * 获取所有歌曲的下载进度
     *
     * @return
     */
    @GetMapping("/progress")
    @ResponseBody
    public List<DownLoad> getProgressMap(int uid) {
        return downLoadService.findLoading(uid);
    }


    /**
     * 歌曲下载
     *
     * @param sid
     * @param uid
     */
    @PostMapping("/song")
    @ResponseBody
    public void downloadSong(Integer[] sid, Integer uid,HttpServletResponse response) {
        flag = false;
        //获取歌曲集合
        List<Song> songs = new ArrayList<Song>();
        for (int i : sid) {
            //先判断歌曲是否被下载过
            Integer res = downLoadService.isDownload(uid, i);
            if (res == null){
                //如果没有下载过，加入下载列表
                Song song = songService.findById(i);
                songs.add(song);
            }
        }

        System.out.println(songs);
        //进行歌曲的下载操作
        //文件下载的url
        String fixedUrl = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_remote_song\\";  //本地测试下载地址
        //String fixedUrl = "/usr/local/tomcat8/apache-tomcat-8.5.57/webapps/music_player_remote_song/";  //服务器使用下载地址
        for (Song song : songs) {
            if (flag){
                return;
            }
            //获取歌曲url,以及歌曲下载地址path
            String url = song.getS_path();
            String fileName = new File(url).getName();  //获取文件名

            System.out.println("开始下载...");
            try {
                File file = new File(fixedUrl+fileName);
                if (!file.exists()){  //如果文件不存在
                    System.out.println("你要找的资源被删除了!");
                    return;
                }
                //获取文件输入流
                input = new FileInputStream(file);
                //处理文件下载url中的中文字符以及空格
                fileName = URLEncoder.encode(fileName, "utf-8").replace("+", "%20");
                //创建添加定义设置文件下载头
                response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
                //创建添加定义设置下载文件类型
                response.setContentType("application/octet-stream");
                //初始化输出流
                output = response.getOutputStream();

                //获取文件大小
                long length = file.length();
                //将文件分为一百份
                long unit = length / 100;
                //现在下载的大小（字节）
                long loadLength = 0;
                //记录当前进度（百分比）
                long nowProgress = 0;
                //保存当前进度（百分比）
                long saveProgress = 0;
                //定义缓冲字节数组
                byte[] bytes = new byte[1];
                int len = 0;
                //进行文件下载
                while ((len = input.read(bytes)) != -1) {
                    //流写入
                    output.write(bytes, 0, len);
                    //下载下载的大小
                    loadLength += len;
                    //计算当前进度
                    nowProgress = loadLength / unit;
                    if (nowProgress >= 1 && nowProgress > saveProgress) {
                        saveProgress = nowProgress;  //保存进度
                        //修改歌曲的下载进度
                        DownLoad downLoad = new DownLoad();
                        downLoad.setS_id(song.getS_id());
                        downLoad.setU_id(uid);
                        downLoad.setStatus(saveProgress);
                        downLoadService.updateStatus(downLoad);
                        System.out.println(saveProgress + "%");
                    }
                }
                System.out.println("一首歌曲下载完毕!");

            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("下载异常！");
            } finally {
                //关闭流
                if (output != null) {
                    try {
                        output.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                if (input != null) {
                    try {
                        input.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }


    /**
     * 使用FileUtils下载文件
     *
     * @param sid
     * @param response
     */
    @RequestMapping("/song/{sid}")
    @ResponseBody
    public void downloadTest(@PathVariable(name = "sid") int sid, HttpServletResponse response) {
        //通过歌曲id获取id信息
        Song song = songService.findById(sid);
        //获取歌曲路径
        String path = song.getS_path();
        String fileName = new File(path).getName();
        String fileName1 = fileName;

        try {
            fileName = URLEncoder.encode(fileName, "utf-8").replace("+", "%20");
            URL url = new URL("http://localhost:8080/music_player_remote_song/" + fileName);
            URLConnection urlConnection = url.openConnection();
            long length = urlConnection.getContentLengthLong();
            System.out.println(length);
            File file = new File("C:\\Users\\3031874211\\Desktop\\downloadTest\\" + fileName1);
            FileUtils.copyURLToFile(url, file);
            System.out.println("下载成功");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /*
     * 使用工具类FileUtils进行文件下载碰坑总结：
     *     下载步骤：
     *        1.获取需要下载的文件的URL地址
     *        2.将URL地址封装为URL对象
     *        3.定义一个file对象，路径就是你要下载的位置
     *        4.调用FileUtils.copyURLToFile(URL,File)方法进行下载操作
     *    碰坑1：
     *      因为Url地址中不能使用中文所以会报java.io.IOException: Server returned HTTP response code: 400 for URL
     *      解决办法：使用URLEncoder.encode(fileName,"utf-8")方法处理中文字符，处理完完毕后这个异常不报了。
     *    碰坑2：解决了问题1，执行代码又报找不到文件异常，之所以会出现这种问题是因为如果路径中存在空格，上面那种方法会使用
     *      +号替换空格，但是tomcat又不能把+号还原回来。
     *      解决办法：先将中文字符用上面那种方法处理掉，然后用"%20"将+号替换掉，解决问题，下载成功
     *
     * */
}
