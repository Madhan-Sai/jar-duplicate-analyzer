/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JarAnalyzer;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class JarData {
    String path;
    long fileSize;
    Date lastModified;
    String filename;

    public JarData(String path, long fileSize, Date lastModified,String filename) {
        this.path = path;
        this.fileSize = fileSize;
        this.lastModified = lastModified;
        this.filename=filename;
    }

    public String getPath() {
        return path;
    }

    public long getFileSize() {
        return fileSize;
    }

    public Date getLastModified() {
        return lastModified;
    }

    public String getFilename() {
        return filename;
    }
    
    
}
