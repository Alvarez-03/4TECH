document.addEventListener("DOMContentLoaded", function() {
    // Detectamos el rol del usuario directamente desde el atributo del DOM (inyectado por el JSP)
    const bodyElement = document.body;
    const rolActual = bodyElement.getAttribute("data-rol") ? bodyElement.getAttribute("data-rol").toUpperCase().trim() : "";

    console.log("Iniciando petición analítica en recurso JS para el rol:", rolActual);

    fetch('SvDashboard')
        .then(response => {
            if (!response.ok) throw new Error("Error HTTP " + response.status);
            return response.json();
        })
        .then(data => {

            // ==========================================
            // FLUJO: SUPERADMIN
            // ==========================================
            if (rolActual === "SUPERADMIN") {
                document.getElementById('saas-total-empresas').innerText = data.totalEmpresas || 0;
                const listaCiudades = data.ciudades || [];
                new Chart(document.getElementById('chartCiudades'), {
                    type: 'pie',
                    data: {
                        labels: listaCiudades.map(c => c.ciudad || "Desconocido"),
                        datasets: [{
                            data: listaCiudades.map(c => c.cantidad || 0),
                            backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6']
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            }

                // ==========================================
                // FLUJO: EMPRESA
            // ==========================================
            else if (rolActual === "EMPRESA") {
                const inversionSegura = data.inversionTotal ? Number(data.inversionTotal) : 0;
                document.getElementById('emp-inversion').innerText = '$ ' + inversionSegura.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});

                const stockCritico = data.stockCritico || [];
                document.getElementById('emp-criticos').innerHTML = `${stockCritico.length} <span class="text-sm font-medium text-gray-400">ítems</span>`;
                document.getElementById('emp-proveedores-count').innerText = (data.itemsProveedor || []).length;

                // Inyección dinámica de la tabla de alertas
                if (stockCritico.length > 0) {
                    const contenedorTabla = document.getElementById('contenedor-tabla-criticos');
                    if(contenedorTabla) contenedorTabla.classList.remove('hidden');

                    const tbody = document.getElementById('tabla-criticos-body');
                    if(tbody) {
                        tbody.innerHTML = "";
                        stockCritico.forEach(p => {
                            tbody.innerHTML += `
                                <tr class="border-b border-gray-100 hover:bg-slate-50 transition-colors">
                                    <td class="p-3 font-semibold text-gray-700">${p.nombre}</td>
                                    <td class="p-3 text-center font-bold text-red-600 bg-red-50/50">${p.cantidad} und</td>
                                </tr>
                            `;
                        });
                    }
                }

                // Gráfico 2: Productos Costosos
                const topProductos = data.topProductos || [];
                new Chart(document.getElementById('chartTopProductos'), {
                    type: 'bar',
                    data: {
                        labels: topProductos.map(p => p.nombre),
                        datasets: [{
                            label: 'Costo Unitario ($)',
                            data: topProductos.map(p => p.costo),
                            backgroundColor: '#3b82f6',
                            borderRadius: 8
                        }]
                    },
                    options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false }
                });

                // Gráfico 3: Estado de Órdenes
                const ordenesEstado = data.ordenesEstado || [];
                new Chart(document.getElementById('chartOrdenesEstado'), {
                    type: 'bar',
                    data: {
                        labels: ordenesEstado.map(o => o.estado),
                        datasets: [{
                            label: 'Órdenes',
                            data: ordenesEstado.map(o => o.total),
                            backgroundColor: '#f59e0b',
                            borderRadius: 8
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });

                // Gráfico 4: Distribución de Proveedores
                const itemsProv = data.itemsProveedor || [];
                new Chart(document.getElementById('chartItemsProveedor'), {
                    type: 'doughnut',
                    data: {
                        labels: itemsProv.map(p => p.proveedor),
                        datasets: [{
                            data: itemsProv.map(p => p.totalItems),
                            backgroundColor: ['#8b5cf6', '#ec4899', '#3b82f6', '#10b981', '#f59e0b']
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });

                // Gráfico 5 (Empresa): Rendimiento del Equipo
                const rendimiento = data.rendimientoEquipo || [];
                new Chart(document.getElementById('chartRendimientoEmpresa'), {
                    type: 'bar',
                    data: {
                        labels: rendimiento.map(e => e.nombre),
                        datasets: [{
                            label: 'Servicios Terminados',
                            data: rendimiento.map(e => e.completadas),
                            backgroundColor: '#6366f1',
                            borderRadius: 6
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            }

                // ==========================================
                // FLUJO: EMPLEADO / TÉCNICO
            // ==========================================
            else if (rolActual === "EMPLEADO") {
                const misOrdenes = data.misOrdenes || [];
                new Chart(document.getElementById('chartMisOrdenes'), {
                    type: 'doughnut',
                    data: {
                        labels: misOrdenes.map(m => m.estado),
                        datasets: [{
                            data: misOrdenes.map(m => m.total),
                            backgroundColor: ['#10b981', '#3b82f6', '#f59e0b']
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });

                const rendimiento = data.rendimientoEquipo || [];
                new Chart(document.getElementById('chartRendimientoEquipo'), {
                    type: 'bar',
                    data: {
                        labels: rendimiento.map(e => e.nombre),
                        datasets: [{
                            label: 'Servicios Terminados',
                            data: rendimiento.map(e => e.completadas),
                            backgroundColor: '#6366f1',
                            borderRadius: 6
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            }
        })
        .catch(error => console.error("Error al poblar el Dashboard desde recurso JS:", error));
});