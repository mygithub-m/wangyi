package cn.learn.utils;


import cn.learn.pojo.Song;
import cn.learn.service.LocalSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import java.util.List;

/**
 * 对于播放列表操作的一些工具方法
 */
@Component
public class PlayListUtils {

    @Autowired
    private LocalSongService localSongService;



    /**
     * 判断一首歌曲是不是存在在播放列表中
     *
     * @param songs
     * @param song
     * @return
     */
    public Integer isPlayList(List<Song> songs, Song song) {
        for (int i = 0; i < songs.size(); i++) {
            if (songs.get(i).getS_id() == song.getS_id() ){ //说明已经存在
                return i;  //返回歌曲在播放列表中的位置
            }
        }
        return null;
    }

    /**
     * 判断一首歌曲是不是本地音乐
     *
     * @return
     */
    public Song isLocal(Song song) {
        //获取本地音乐
        List<Song> localSongs = getLocalSongs();
        //设置默认的歌曲播放源为远程
        song.setS_type(1);
        //查询本地音乐
        for (Song localSong : localSongs) {
            if (localSong.getS_id() == song.getS_id()) {  //说明歌曲是本地音乐
                //设置歌曲的类型 0 为本地音乐  1为远程音乐
                song.setS_type(0);
                //设置歌曲路径
                song.setS_path(localSong.getS_path());
            }
        }
        return song;
    }


    /**
     * 获取本地音乐列表
     *
     * @return
     */
    public List<Song> getLocalSongs() {
        //调用工具类获取本地音乐文件
        List<Song> localSongs = FileUtil.getLocalSongs();

        for (Song song : localSongs) {   //获取远程音乐id,并将其赋值给对应歌曲
            Song newSong = localSongService.selectByLocal(song);
            if (newSong != null){
                song.setS_id(newSong.getS_id());
            }
        }
        return localSongs;
    }

}
