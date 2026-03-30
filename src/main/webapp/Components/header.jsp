<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String titulo = (request.getAttribute("titulo") != null)
          ? (String)request.getAttribute("titulo")
          : "4TECH";
%>
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <script src="resources/ControlsButton.js"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter', 'ui-sans-serif', 'system-ui'],
          },
          colors: {
            'primary': '#1d4ed8',
            'secondary': '#EF2917',
            'accent': '#FFBA08',
            'gray-ebony':'#515751',
          }
        }
      }
    }
  </script>
</head>
<header class="bg-white text-white shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">

      <div class="flex items-center gap-3">
        <button onclick="toggleMenu()" class="bg-blue-600 hover:bg-blue-700 text-white p-3 rounded-lg shadow-md transition-all active:scale-95">
          <i class="fa-solid fa-bars text-2xl"></i>
        </button>
        <img class="h-14 w-14 object-contain" src="IMG/4TECH.png" alt="Logo 4TECH">
        <h1 class="text-2xl font-bold tracking-tight text-primary"><%= titulo %></h1>
      </div>
      <div class="hidden md:block">
        <button class="bg-blue-600 w-28 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-semibold transition-all" onclick="CerrarSesion()">
          <i class="fa-solid fa-arrow-right-from-bracket mx-1"></i>
          Salir
        </button>
      </div>
    </div>
  </div>
</header>

<div id="overlay" class="fixed inset-0 bg-black/50 z-40 hidden transition-opacity" onclick="toggleMenu()"></div>
  <%@include file="submenu.jsp" %>
