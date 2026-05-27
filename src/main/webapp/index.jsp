<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>4TECH | Control de ordenes de servicio.</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            brand: {
              50: '#f0f7ff',
              100: '#e0effe',
              600: '#2563eb',
              700: '#1d4ed8',
              800: '#1e40af',
              900: '#1e3a8a',
            }
          }
        }
      }
    }
  </script>

  <style>
    .scroll-reveal {
      opacity: 0;
      filter: blur(4px);
      transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .reveal-fade-up { transform: translateY(30px); }
    .reveal-fade-left { transform: translateX(-40px); }
    .reveal-fade-right { transform: translateX(40px); }

    /* Clase activa que inyectará el script al hacer scroll */
    .scroll-reveal.active {
      opacity: 1;
      filter: blur(0);
      transform: translate(0);
    }
  </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 antialiased selection:bg-brand-600 selection:text-white">

<nav class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200 px-6 py-4 flex justify-between items-center">
  <div class="flex items-center gap-2">
    <img src="IMG/4TECH.png" alt="logo4TECH" class="w-16 h-16 object-contain">
  </div>
  <div class="hidden md:flex items-center gap-8 font-semibold text-slate-600">
    <a href="#que-es" class="hover:text-brand-600 transition-colors">¿Qué es?</a>
    <a href="#funcionalidades" class="hover:text-brand-600 transition-colors">¿Para qué sirve?</a>
    <a href="#precios" class="hover:text-brand-600 transition-colors">Precios</a>
    <a href="#faq" class="hover:text-brand-600 transition-colors">Preguntas Frecuentes</a>
  </div>
  <div class="flex flex-wrap items-center justify-center gap-2.5">
    <a href="Consulta.jsp" class="bg-brand-600 hover:bg-brand-700 text-white font-bold px-5 py-2.5 rounded-xl transition-all shadow-md shadow-brand-600/20 text-sm flex items-center gap-2">
      <i class="fa-solid fa-magnifying-glass text-xs"></i> Consultar mi Orden
    </a>
    <span class="hidden sm:inline text-slate-300">|</span>

    <a href="loginEmpresarial.jsp" class="bg-slate-900 hover:bg-slate-800 text-white font-bold px-4 py-2 rounded-xl transition-all text-xs flex items-center gap-2 shadow-sm active:scale-95">
      <i class="fa-solid fa-building text-brand-400"></i> Portal Empresa
    </a>

    <a href="loginEmpleados.jsp" class="bg-brand-600 hover:bg-brand-700 text-white font-bold px-4 py-2 rounded-xl transition-all text-xs flex items-center gap-2 shadow-md shadow-brand-600/10 active:scale-95">
      <i class="fa-solid fa-user-gear text-brand-200"></i> Portal Empleado
    </a>
  </div>
</nav>

<header class="relative overflow-hidden bg-gradient-to-b from-brand-50 via-white to-slate-50 py-20 lg:py-32 px-6">
  <div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
    <div class="space-y-6 text-center lg:text-left scroll-reveal reveal-fade-left">
      <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-slate-900 tracking-tight leading-tight">
        El sistema definitivo para tu <span class="text-transparent bg-clip-text bg-gradient-to-r from-brand-600 to-brand-800">Negocio.</span>
      </h1>
      <p class="text-lg text-slate-600 max-w-xl mx-auto lg:mx-0">
        Controla órdenes de servicio, administra el inventario de repuestos y mantén informados a tus clientes en tiempo real. Todo desde una sola plataforma.
      </p>
      <div class="flex flex-col sm:flex-row flex-wrap gap-4 justify-center lg:justify-start">
        <a href="Consulta.jsp" class="bg-brand-600 hover:bg-brand-700 text-white font-bold px-8 py-4 rounded-xl text-center shadow-lg shadow-brand-600/20 transition-transform active:scale-95 flex items-center justify-center gap-2">
          <i class="fa-solid fa-magnifying-glass"></i> Consultar mi Orden
        </a>

        <a href="#precios" class="bg-slate-900 hover:bg-slate-800 text-white font-bold px-8 py-4 rounded-xl text-center shadow-lg transition-transform active:scale-95">
          Ver Planes y Precios
        </a>

        <a href="#que-es" class="bg-white hover:bg-slate-100 text-slate-700 font-bold px-8 py-4 rounded-xl text-center border border-slate-200 shadow-sm transition-transform active:scale-95">
          Conocer más
        </a>
      </div>
    </div>
    <div class="relative mx-auto lg:ml-auto max-w-md lg:max-w-none w-full scroll-reveal reveal-fade-right">
      <div class="absolute -inset-1 rounded-2xl bg-gradient-to-r from-brand-600 to-indigo-600 opacity-20 blur-xl"></div>
      <div class="relative bg-white border border-slate-200 rounded-2xl shadow-2xl p-6 space-y-4">
        <div class="flex items-center justify-between border-b border-slate-100 pb-3">
          <div class="flex items-center gap-2">
            <span class="h-3 w-3 rounded-full bg-red-400"></span>
            <span class="h-3 w-3 rounded-full bg-yellow-400"></span>
            <span class="h-3 w-3 rounded-full bg-green-400"></span>
            <span class="text-xs text-slate-400 ml-2 font-mono">4TECH mi orden de servicio.</span>
          </div>
          <span class="bg-green-100 text-green-800 text-[10px] font-black px-2 py-0.5 rounded-full uppercase">EN PROCESO</span>
        </div>
        <div class="space-y-2">
          <div class="h-4 bg-slate-100 rounded w-1/3"></div>
          <div class="h-8 bg-brand-50 rounded-lg w-full flex items-center px-3 justify-between">
            <span class="text-xs font-mono text-brand-700 font-bold">ORD-0042</span>
            <span class="text-[10px] text-slate-400">PROOFCODE</span>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-3 text-[11px]">
          <div class="bg-slate-50 p-3 rounded-lg border border-slate-100">
            <span class="font-bold block text-slate-700">Reporte del Cliente</span>
            <span class="text-slate-500">Cambio de pantalla y batería muerta.</span>
          </div>
          <div class="bg-slate-50 p-3 rounded-lg border border-slate-100">
            <span class="font-bold block text-slate-700">Insumos Utilizados</span>
            <span class="text-brand-600 font-mono font-bold"><i class="fa-solid fa-check"></i> 1x Pantalla OLED</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>

<section id="que-es" class="py-20 px-6 max-w-6xl mx-auto border-t border-slate-100">
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
    <div class="bg-gradient-to-br from-brand-900 to-brand-700 text-white p-8 lg:p-12 rounded-3xl shadow-xl relative overflow-hidden scroll-reveal reveal-fade-left">
      <div class="absolute right-0 bottom-0 translate-x-1/4 translate-y-1/4 opacity-10">
        <i class="fa-solid fa-code text-[200px]"></i>
      </div>
      <span class="text-xs font-bold text-brand-200 uppercase tracking-widest block mb-2">Detrás del Software</span>
      <h2 class="text-2xl lg:text-3xl font-black mb-4">¿Quién es PROOFCODE?</h2>
      <p class="text-brand-100 leading-relaxed text-sm lg:text-base">
        Somos una empresa de desarrollo software de alto impacto y rendimiento arquitectónico. En <strong>PROOFCODE</strong> no creamos sistemas genéricos; diseñamos herramientas sólidas, seguras y optimizadas para solucionar problemas reales del mercado empresarial. Creemos en el código limpio, escalable y en interfaces que sus empleados y clientes amen usar desde el primer día.
      </p>
    </div>
    <div class="space-y-6 scroll-reveal reveal-fade-right">
      <span class="text-xs font-bold text-brand-600 uppercase tracking-widest block">El Producto</span>
      <h2 class="text-3xl font-extrabold text-slate-900 tracking-tight">¿Porque elegir 4TECH?</h2>
      <p class="text-slate-600 leading-relaxed">
        <strong>4TECH</strong> es un ecosistema ERP modular diseñado específicamente para laboratorios de soporte técnico, talleres de reparación de electrónica y centros de servicio profesional.
      </p>
      <p class="text-slate-600 leading-relaxed">
        Nació para erradicar el desorden de las hojas de cálculo, las notas de papel perdidas y la falta de comunicación con el cliente. Conecta en una sola base de datos centralizada a los administradores, ingenieros técnicos y al usuario final.
      </p>
    </div>
  </div>
</section>

<section id="funcionalidades" class="bg-slate-900 text-white py-20 px-6">
  <div class="max-w-6xl mx-auto space-y-12">
    <div class="text-center max-w-2xl mx-auto space-y-4 scroll-reveal reveal-fade-up">
      <h2 class="text-3xl font-extrabold sm:text-4xl">¿Para qué sirve 4TECH?</h2>
      <p class="text-slate-400 text-sm sm:text-base">Descubre cómo automatizar el flujo operativo diario de tu negocio y escalar tu rentabilidad.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <div class="bg-slate-800 border border-slate-700 p-6 rounded-2xl space-y-4 transition-all hover:-translate-y-1 scroll-reveal reveal-fade-up" style="transition-delay: 100ms;">
        <div class="h-12 w-12 bg-brand-600/20 text-brand-400 rounded-xl flex items-center justify-center text-xl">
          <i class="fa-solid fa-rectangle-list"></i>
        </div>
        <h3 class="text-lg font-bold text-white">Gestión Integral de Órdenes</h3>
        <p class="text-slate-400 text-sm leading-relaxed">Registra ingresos con reportes detallados del cliente, asigna técnicos responsables y actualiza el estado operativo de cada orden de servicio.</p>
      </div>
      <div class="bg-slate-800 border border-slate-700 p-6 rounded-2xl space-y-4 transition-all hover:-translate-y-1 scroll-reveal reveal-fade-up" style="transition-delay: 200ms;">
        <div class="h-12 w-12 bg-brand-600/20 text-brand-400 rounded-xl flex items-center justify-center text-xl">
          <i class="fa-solid fa-cubes"></i>
        </div>
        <h3 class="text-lg font-bold text-white">Sincronización de Inventario</h3>
        <p class="text-slate-400 text-sm leading-relaxed">Asocia repuestos directamente a cada orden de servicio, descontando existencias automáticamente y evitando pérdidas ruidosas.</p>
      </div>
      <div class="bg-slate-800 border border-slate-700 p-6 rounded-2xl space-y-4 transition-all hover:-translate-y-1 scroll-reveal reveal-fade-up" style="transition-delay: 300ms;">
        <div class="h-12 w-12 bg-brand-600/20 text-brand-400 rounded-xl flex items-center justify-center text-xl">
          <i class="fa-solid fa-users-viewfinder"></i>
        </div>
        <h3 class="text-lg font-bold text-white">Consulta Pública Transparente</h3>
        <p class="text-slate-400 text-sm leading-relaxed">Tus clientes pueden consultar el avance real de su equipo ingresando su identificación o número de orden. Transparencia total sin llamadas telefónicas extras.</p>
      </div>
      <div class="bg-slate-800 border border-slate-700 p-6 rounded-2xl space-y-4 transition-all hover:-translate-y-1 scroll-reveal reveal-fade-up" style="transition-delay: 400ms;">
        <div class="h-12 w-12 bg-brand-600/20 text-brand-400 rounded-xl flex items-center justify-center text-xl">
          <i class="fa-solid fa-chart-pie"></i>
        </div>
        <h3 class="text-lg font-bold text-white">Estadísticas y Rendimiento</h3>
        <p class="text-slate-400 text-sm leading-relaxed">Visualiza cuántas órdenes están pendientes, cuántas han sido completadas con éxito y evalúa el rendimiento diario de tu equipo de ingenieros.</p>
      </div>
      <div class="bg-slate-800 border border-slate-700 p-6 rounded-2xl space-y-4 transition-all hover:-translate-y-1 scroll-reveal reveal-fade-up" style="transition-delay: 500ms;">
        <div class="h-12 w-12 bg-brand-600/20 text-brand-400 rounded-xl flex items-center justify-center text-xl">
          <i class="fa-solid fa-shield-halved"></i>
        </div>
        <h3 class="text-lg font-bold text-white">Seguridad y Respaldo de Datos</h3>
        <p class="text-slate-400 text-sm leading-relaxed">Lógica de negocio robusta con bases de datos relacionales seguras. Tu información de clientes e historial técnico blindada contra imprevistos.</p>
      </div>
    </div>
  </div>
</section>

<section id="precios" class="py-20 px-6 max-w-5xl mx-auto">
  <div class="text-center max-w-2xl mx-auto space-y-4 mb-16 scroll-reveal reveal-fade-up">
    <span class="text-xs font-bold text-brand-600 uppercase tracking-widest block">Inversión Inteligente</span>
    <h2 class="text-3xl font-extrabold sm:text-4xl text-slate-900">Planes diseñados para crecer</h2>
    <p class="text-slate-500 text-sm">Elige la modalidad de pago que mejor se ajuste a tu negocio.</p>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
    <div class="bg-white border border-slate-200 rounded-2xl p-8 flex flex-col justify-between shadow-sm relative transition-all hover:border-slate-300 scroll-reveal reveal-fade-left">
      <div class="space-y-6">
        <div>
          <h3 class="text-xl font-bold text-slate-900">Suscripción Mensual</h3>
          <p class="text-xs text-slate-400 mt-1">mes a mes</p>
        </div>
        <div class="flex items-baseline text-slate-900">
          <span class="text-3xl font-bold tracking-tight">$</span>
          <span class="text-5xl font-black tracking-tight">29.000 COP</span>
          <span class="text-slate-500 ml-1 text-sm">/ mes</span>
        </div>
        <ul class="space-y-3.5 text-sm text-slate-600 border-t border-slate-100 pt-6">
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-brand-600 text-xs"></i> Órdenes de servicio ilimitadas</li>
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-brand-600 text-xs"></i> Gestión de Inventario</li>
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-brand-600 text-xs"></i> Módulo de consulta pública para clientes</li>
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-brand-600 text-xs"></i> Soporte técnico vía email estándar</li>
        </ul>
      </div>
      <button class="w-full mt-8 bg-slate-900 hover:bg-slate-800 text-white font-bold py-3.5 rounded-xl transition-all">
        Iniciar Plan Mensual
      </button>
    </div>

    <div class="bg-white border-2 border-brand-600 rounded-2xl p-8 flex flex-col justify-between shadow-md relative transition-all scroll-reveal reveal-fade-right">
      <div class="absolute top-0 right-6 -translate-y-1/2 bg-brand-600 text-white text-[11px] font-black uppercase px-3 py-1 rounded-full tracking-wider shadow">
        ¡Ahorra 10% en tu año!
      </div>
      <div class="space-y-6">
        <div>
          <h3 class="text-xl font-bold text-slate-900">Suscripción Anual</h3>
          <p class="text-xs text-brand-600 font-semibold mt-1">La opción favorita para tu negocio.</p>
        </div>
        <div class="flex items-baseline text-slate-900">
          <span class="text-3xl font-bold tracking-tight">$</span>
          <span class="text-5xl font-black tracking-tight">313.000 COP</span>
          <span class="text-slate-500 ml-1 text-sm">/ año</span>
        </div>
        <p class="text-xs bg-brand-50 text-brand-700 px-3 py-1.5 rounded-lg inline-block font-medium">Equivale a solo $26.083 COP al mes.</p>
        <ul class="space-y-3.5 text-sm text-slate-600 border-t border-slate-100 pt-6">
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-green-600 text-xs"></i> <strong>Todo</strong> lo incluido en el plan mensual</li>
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-green-600 text-xs"></i> Soporte técnico prioritario 24/7</li>
          <li class="flex items-center gap-2.5"><i class="fa-solid fa-circle-check text-green-600 text-xs"></i> Actualizaciones automáticas del sistema sin costo</li>
        </ul>
      </div>
      <button class="w-full mt-8 bg-brand-600 hover:bg-brand-700 text-white font-bold py-3.5 rounded-xl transition-all shadow-lg shadow-brand-600/20">
        Adquirir Plan Anual
      </button>
    </div>
  </div>
</section>

<section id="faq" class="bg-slate-100 py-20 px-6">
  <div class="max-w-4xl mx-auto space-y-12">
    <div class="text-center max-w-2xl mx-auto space-y-3 scroll-reveal reveal-fade-up">
      <h2 class="text-3xl font-extrabold text-slate-900">Preguntas Frecuentes</h2>
      <p class="text-slate-500 text-sm">¿Tienes dudas? Aquí resolvemos las preguntas más habituales de nuestros clientes.</p>
    </div>

    <div class="space-y-4">
      <div class="bg-white p-6 rounded-xl border border-slate-200 scroll-reveal reveal-fade-up" style="transition-delay: 100ms;">
        <h3 class="font-bold text-slate-900 text-base mb-2">¿Cómo consultan los clientes el estado de sus equipos?</h3>
        <p class="text-slate-600 text-sm leading-relaxed">A través del módulo público seguro. Solo necesitan digitar su número de cédula o el código de orden generado por el sistema para ver en tiempo real diagnósticos, observaciones y repuestos usados.</p>
      </div>
      <div class="bg-white p-6 rounded-xl border border-slate-200 scroll-reveal reveal-fade-up" style="transition-delay: 200ms;">
        <h3 class="font-bold text-slate-900 text-base mb-2">¿El software requiere instalación en cada computador del taller?</h3>
        <p class="text-slate-600 text-sm leading-relaxed">No. 4TECH es un ecosistema desarrollado con tecnologías web modernas, lo que significa que puedes acceder de forma segura desde cualquier computadora, tablet o smartphone con conexión a internet.</p>
      </div>
      <div class="bg-white p-6 rounded-xl border border-slate-200 scroll-reveal reveal-fade-up" style="transition-delay: 300ms;">
        <h3 class="font-bold text-slate-900 text-base mb-2">¿Ofrece PROFFCODE soporte personalizado en caso de fallos?</h3>
        <p class="text-slate-600 text-sm leading-relaxed">Por supuesto. Nuestro equipo de desarrollo monitorea la estabilidad de los servidores de forma permanente y resolvemos solicitudes de asistencia técnica de inmediato.</p>
      </div>
    </div>
  </div>
</section>

<footer class="bg-slate-900 text-slate-400 border-t border-slate-800 text-xs py-12 px-6">
  <div class="max-w-6xl mx-auto flex flex-col md:flex-row justify-between items-center gap-6">
    <div class="text-center md:text-left space-y-1">
      <p class="text-base text-white font-black italic tracking-wider">4TECH</p>
      <p>© 2026 PROOFCODE. Todos los derechos reservados.</p>
    </div>
    <div class="flex items-center gap-6 font-medium">
      <a href="#que-es" class="hover:text-white transition-colors">Nosotros</a>
      <a href="#funcionalidades" class="hover:text-white transition-colors">Funciones</a>
      <a href="#precios" class="hover:text-white transition-colors">Planes</a>
    </div>
  </div>
</footer>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const elementosARevelar = document.querySelectorAll(".scroll-reveal");

    const configuracionObserver = {
      root: null, // Usa el viewport completo del navegador
      rootMargin: "0px",
      threshold: 0.15 // El elemento se activa cuando el 15% de su cuerpo es visible
    };

    const observer = new IntersectionObserver(function (entries, observer) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          // Añade la clase que activa la animación CSS
          entry.target.classList.add("active");
          // Opcional: Deja de observar el elemento una vez animado para mejorar rendimiento
          observer.unobserve(entry.target);
        }
      });
    }, configuracionObserver);

    // Activamos el observador para cada componente configurado
    elementosARevelar.forEach(elemento => {
      observer.observe(elemento);
    });
  });
</script>
</body>
</html>