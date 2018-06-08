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
import java.net.URL;
import java.util.Date;
import java.util.Enumeration;
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
import org.apache.commons.io.FileUtils;

/**
 *
 * @author Administrator
 */
public class urlaction extends HttpServlet {

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
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet urlaction</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet urlaction at " + request.getContextPath() + "</h1>");
            String link=request.getParameter("link");
            URL url=new URL(link);
            String filename=link.substring(link.lastIndexOf("/")+1);
            ServletContext sc=this.getServletContext();
            String fpath=sc.getInitParameter("destLocation");
            String dirpath=System.getProperty("user.dir");
            fpath=dirpath+fpath+filename;
            File f=new File(fpath);
            FileUtils.copyURLToFile(url,f);
            //out.println("<p>"+link+"</p>");
            //out.println("<p>"+link+"</p>");
            if(filename.endsWith(".zip")){
                out.println("<p>"+fpath+"</p>");
                unzipAndStore(request,response,fpath,fpath+filename);
            }
            else if(filename.endsWith(".jar")){
                extractJar(request,response,fpath);
            }
            out.println("</body>");
            out.println("</html>");                    
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
        processRequest(request, response);
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
        processRequest(request, response);
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
                    JarFile jar=new JarFile(fpath);
                    Enumeration<JarEntry> jarentries=jar.entries();
                    while(jarentries.hasMoreElements()){
                        JarData djar=null;
                        JarEntry content=jarentries.nextElement();
                        djar=new JarData(content.getName(),content.getSize(),new Date(content.getTime()));
                        parse.addData(djar);
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
     private void extractJar(HttpServletRequest request,HttpServletResponse response,String source) throws IOException{
            JarParser parse=new JarParser();
            JarFile jar=new JarFile(source);
            Enumeration<JarEntry> jarentries=jar.entries();
            while(jarentries.hasMoreElements()){
                JarData djar=null;
                JarEntry content=jarentries.nextElement();
                djar=new JarData(content.getName(),content.getSize(),new Date(content.getTime()));
                parse.addData(djar);
            }
            if(parse!=null){
                request.getSession().setAttribute("jardata",parse);
                response.sendRedirect("listing.jsp");
            }
            else{
                request.getSession().setAttribute("error","No jar file in this folder");
                response.sendRedirect("index.jsp");
            }
        File del=new File(source);
        del.delete();
    }
}
