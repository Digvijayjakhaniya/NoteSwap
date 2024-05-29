<h1>Old Currency Notes and Vintage Item Selling and Purchase App</h1>

<h2>Overview</h2>

<p>The "Old Currency Notes and Vintage Item Selling and Purchase App" is a digital platform designed to connect collectors and sellers of historical paper currency and vintage items. The app enables users to create listings for currency notes and vintage items, search for specific items, and communicate securely. This platform aims to provide a convenient and secure environment for trading items of historical and cultural value.</p>

<h2>Table of Contents</h2>

<ol>
    <li><a href="#features">Features</a></li>
    <li><a href="#tech-stack">Tech Stack</a></li>
    <li><a href="#architecture">Architecture</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#usage">Usage</a></li>
</ol>

<h2 id="features">Features</h2>

<ul>
  <li><strong>User Registration and Authentication:</strong> Secure registration and login system.</li>
  <li><strong>Listing Creation:</strong> Users can create and manage their listings for old currency notes and vintage items.</li>
  <li><strong>Search and Filter:</strong> Advanced search functionality to find specific items.</li>
  <li><strong>Contact:</strong> Secure communication between buyers and sellers using URLlauncher.</li>
  <li><strong>Admin Panel:</strong> Administrative interface for managing users and listings.</li>
</ul>

<h2 id="tech-stack">Tech Stack</h2>

<h3>Backend</h3>

<ul>
  <li><strong>Language:</strong> PHP</li>
  <li><strong>Database:</strong> MySQL</li>
</ul>

<h3>Frontend</h3>

<ul>
  <li><strong>Mobile Application:</strong> Flutter</li>
</ul>

<h3>Tools and Libraries</h3>

<ul>
  <li><strong>API Testing:</strong> Postman </li>
  <li><strong>Database Management:</strong> phpMyAdmin</li>
</ul>

<h2 id="architecture">Architecture</h2>

<p>The application follows a client-server architecture with the following components:</p>

<ul>
  <li><strong>Client Side:</strong> Flutter-based Android application</li>
  <li><strong>Server Side:</strong> PHP backend with RESTful APIs</li>
  <li><strong>Database:</strong> MySQL</li>
</ul>

<p><strong>High-Level Diagram</strong></p>

<pre>
|-------------|      |---------------|      |---------------|
|   Flutter   | &lt;--&gt; | PHP Backend   | &lt;--&gt; | MySQL Database|
|  Application|      | (REST API)    |      |               |
|-------------|      |---------------|      |---------------|
</pre>

<h2 id="installation">Installation</h2>

<h3>Prerequisites</h3>

<ul>
  <li>PHP</li>
  <li>MySQL</li>
  <li>Flutter SDK</li>
  <li>Android Studio</li>
</ul>

<h3>Backend Setup</h3>

<ol>
  <li>Clone the repository:<br>
      <pre><code>git clone https://github.com/Digvijayjakhaniya/NoteSwap.git <br>
cd NoteSwap/admin</code></pre>
    put this code in your <b>htdoc</b> folder*
  </li>
  
  <li>Import SQL:<br>
     import sql file in your phpmyadmin
  </li>
  <li> start server:<br>
    and run this url in browser
    <code>http://localhost/project/noteswap/admin/</code>
  </li>

</ol>

<h3>Frontend Setup</h3>

<ol>
  <li>Navigate to the Flutter project directory:<br>
      <code>cd flutter</code>
  </li>
  <li>Install dependencies:<br>
      <code>flutter pub get</code>
  </li>
  <li>Run the application:<br>
      <code>flutter run</code>
  </li>
</ol>

<h3>Relationships</h3>

<ul>
  <li>Each user can have multiple listings.</li>
</ul>

<h2 id="usage">Usage</h2>

<ol>
  <li><strong>Registration:</strong> Users can sign up for an account.</li>
  <li><strong>Login:</strong> Registered users can log in to their account.</li>
  <li><strong>Create Listings:</strong> Users can create and manage their listings.</li>
  <li><strong>Search Listings:</strong> Users can search and filter listings based on various criteria.</li>
  <li><strong>Contact:</strong> Users can communicate securely via URL launcher to text message or WhatsApp or call.</li>
</ol>

 <br><br><hr>
  <footer class="card-footer bg-white pt-2">
    <p>© 2024 Made with 🤍 by <a href="https://digvijay.rf.gd" target="_blank" class="link-danger page-link alert-link d-inline">Digvijay Jakhaniya</a></p>
  </footer>
