/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import JarAnalyzer.JarData;
import JarAnalyzer.JarParser;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author Administrator
 */
public class zipaction extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet zipaction</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet zipaction at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
            File f;
            long secs;
            int totcount=0,notzip=0;
            ServletContext sc=this.getServletContext();//gets servlets contexts
            String fpath=sc.getInitParameter("destLocation");//takes value of the parameter name(deployment descriptor)
            String dirpath=System.getProperty("user.dir");//current server directory
            fpath=dirpath+fpath+new SecureRandom().nextInt()+"\\";//appends directory path with file path
            out.println(fpath);
            String type=request.getContentType();//identifies the encryption type of the form
            if(type.contains("multipart/form-data")){
                DiskFileItemFactory df=new DiskFileItemFactory();
                File tempdir=new File(dirpath+"\\webapps\\JARAnalyzer\\temp");
                if(!tempdir.exists()){
                    tempdir.mkdirs();//creates temp directory
                }
                File dest=new File(fpath);//empty file object gets created in the folder fpath
                if(!dest.exists()){
                    dest.mkdirs();
                }
                df.setRepository(tempdir);
                ServletFileUpload sfu=new ServletFileUpload(df);
                try {
                    List files=sfu.parseRequest(request);
                    Iterator i=files.iterator();
                    while(i.hasNext()){
                        totcount++;
                        FileItem fitem=(FileItem)i.next();
                        String name=fitem.getName();
                        if(name!=null){
                        if(name.endsWith(".zip")){
                            if(name.lastIndexOf("//")>=0){
                                f=new File(fpath+name.substring(name.lastIndexOf("//")));
                            }
                            else{
                                f=new File(fpath+name.substring(name.lastIndexOf("//")+1));
                            }
                            
                            fitem.write(f);
                            String dir=name.substring(0,name.indexOf(".zip"));
                            File d=new File(fpath+dir);
                            if(!d.exists()) 
                                d.mkdirs();
                            String source=fpath+name;
                            String destination=fpath+dir;
                            unzipAndStore(request,response,source,destination);
                        }
                        else
                            notzip++;
                        }
                    }
                    if(totcount==notzip){
                        HttpSession session=request.getSession();
                        session.setAttribute("error","No files with .zip extension");
                        response.sendRedirect("index.jsp");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(zipaction.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(zipaction.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(zipaction.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void unzipAndStore(HttpServletRequest request,HttpServletResponse response,String src, String dest) {
        String data = null;
        JarParser parse=new JarParser();
        byte[]buffer=new byte[1024];
        try (FileInputStream fis = new FileInputStream(src); ZipInputStream zis = new ZipInputStream(fis)) {
            PrintWriter out=response.getWriter();
            ZipEntry ze=zis.getNextEntry();
            int count=0;
            String fpath;
            while(ze != null){
                String filename = ze.getName();
                if(filename.endsWith(".jar")){
                    fpath=dest+File.separator+filename;
                    File newFile = new File(fpath);
                    new File(newFile.getParent()).mkdirs();
                    FileOutputStream fos = new FileOutputStream(newFile);
                    int len;
                    while ((len = zis.read(buffer)) > 0) {
                        fos.write(buffer, 0, len);
                    }
                    JarFile jar=new JarFile(fpath);String jarname;
                    Enumeration<JarEntry> jarentries=jar.entries();
                    while(jarentries.hasMoreElements()){
                        if(fpath.contains("/")){
                            jarname=fpath.substring(fpath.lastIndexOf("/"));
                        }else{
                            jarname=fpath;
                        }
                        JarData djar=null;
                        JarEntry content=jarentries.nextElement();
                        djar=new JarData(content.getName(),content.getSize(),new Date(content.getTime()),jarname);
                        parse.addData(djar);
                        parse.addFolders(djar);
                    }
                    
                     fos.close();
                     
                }
                //close this ZipEntry
                zis.closeEntry();
                ze = zis.getNextEntry();
            }
            out.println(File.separator);
            //response.sendRedirect("listing.jsp");
            //extractJar(request,response);
            if(parse!=null){
                request.getSession().setAttribute("jardata",parse);
                response.sendRedirect("listing.jsp");
            }
            else{
                request.getSession().setAttribute("error","No jar file in this folder");
                response.sendRedirect("index.jsp");
            }
        }
        catch (Exception ex) {
            Logger.getLogger(zipaction.class.getName()).log(Level.SEVERE, null, ex);
        }
        File del=new File(src);
        del.delete();
    }
}