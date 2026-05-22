/**
 * SmartAgri v4 — app.js
 * Unified flow: Login → Farm → [Soil Scan → Sensor Fetch → Crop Recommend] → Maintenance → Disease
 */

/* ═══════ STATE ═══════ */
const S = {
  user: null, farms: [], activeFarm: null,
  soilType: null, sensorData: null,
  selectedCrop: null, cropStartDate: null,
  notifications: [], charts: {},
};

const save = () => { try { localStorage.setItem('sa4', JSON.stringify(S)); } catch(e){} };
const load = () => { try { const d = localStorage.getItem('sa4'); if(d) Object.assign(S, JSON.parse(d)); } catch(e){} };

const rnd  = (lo, hi) => Math.round(lo + Math.random()*(hi-lo));
const rndF = (lo, hi, d=1) => parseFloat((lo + Math.random()*(hi-lo)).toFixed(d));

/* ═══════ TOAST ═══════ */
function toast(msg, type='success', dur=3500) {
  const w = document.getElementById('toastWrap');
  const t = document.createElement('div');
  t.className = `toast ${type}`;
  t.innerHTML = msg;
  w.appendChild(t);
  setTimeout(() => { t.style.opacity='0'; t.style.transform='translateX(30px)'; setTimeout(()=>t.remove(), 300); }, dur);
}

function setHTML(id, html) { const e = document.getElementById(id); if(e) e.innerHTML = html; }
function show(id) { const e = document.getElementById(id); if(e) e.style.display=''; }
function hide(id) { const e = document.getElementById(id); if(e) e.style.display='none'; }
function showBlock(id) { const e = document.getElementById(id); if(e) e.style.display='block'; }

/* ═══════ AUTH ═══════ */
function switchAuth(mode) {
  document.getElementById('loginPanel').classList.toggle('active', mode === 'login');
  document.getElementById('signupPanel').classList.toggle('active', mode === 'signup');
}

function doLogin() {
  const email = document.getElementById('liEmail').value.trim();
  const pass  = document.getElementById('liPass').value;
  if (!email || !pass) { toast('Please enter email and password', 'error'); return; }
  S.user = {
    name: email.split('@')[0].replace(/[._\-]/g,' ').split(' ')
              .map(w=>w.charAt(0).toUpperCase()+w.slice(1)).join(' '),
    email
  };
  save(); initApp();
  toast(`🌾 Welcome back, ${S.user.name}!`, 'success');
}

function doSignup() {
  const name  = document.getElementById('suName').value.trim();
  const email = document.getElementById('suEmail').value.trim();
  const pass  = document.getElementById('suPass').value;
  if (!name || !email || !pass) { toast('Please fill all fields', 'error'); return; }
  if (pass.length < 6) { toast('Password must be at least 6 characters', 'error'); return; }
  S.user = { name, email };
  save(); initApp();
  toast(`🎉 Account created! Welcome, ${name}!`, 'success');
}

function doLogout() {
  if (!confirm('Sign out of SmartAgri?')) return;
  localStorage.removeItem('sa4');
  location.reload();
}

function switchAccount() {
  hide('profileDropdown');
  localStorage.removeItem('sa4');
  location.reload();
}

/* ═══════ APP INIT ═══════ */
function initApp() {
  hide('authScreen');
  show('mainApp');
  document.getElementById('mainApp').style.display = 'block';

  // Setup user UI
  const ini = S.user.name.charAt(0).toUpperCase();
  setHTML('profileAvatar', ini);
  setHTML('pdName', S.user.name);
  setHTML('pdEmail', S.user.email);
  setHTML('drawerName', S.user.name);
  setHTML('drawerEmail', S.user.email);
  setHTML('welcomeName', S.user.name.split(' ')[0]);

  if (!S.farms || !S.farms.length) initDefaultFarms();
  if (!S.activeFarm) S.activeFarm = S.farms[0];
  
  updateActiveFarmUI();
  initNotifications();
  buildDiseaseCatalogue();
  updateDashboardKpis();
  initDashCharts();
  
  // Time greeting
  const h = new Date().getHours();
  const greet = h < 12 ? 'morning' : h < 17 ? 'afternoon' : 'evening';
  setHTML('timeGreet', greet);
  
  // Date
  setHTML('dashDate', new Date().toLocaleDateString('en-IN', {weekday:'long', year:'numeric', month:'short', day:'numeric'}));

  // If sensor data already loaded, show it
  if (S.sensorData) refreshDashSensors();

  // Request browser notification permission
  if ('Notification' in window && Notification.permission === 'default') {
    Notification.requestPermission();
  }
  
  // Fetch live weather forecast
  fetchWeatherForecast();
}

/* ═══════ FARMS ═══════ */
function initDefaultFarms() {
  S.farms = [
    { id:'f1', name:'Demo Farm Alpha', location:'Karnataka, India',  area:8,  soil:'loamy', activeCrop: null },
    { id:'f2', name:'Demo Farm Beta',  location:'Punjab, India',     area:12, soil:'sandy', activeCrop: null },
  ];
  S.activeFarm = S.farms[0];
  save();
}

function updateActiveFarmUI() {
  if (!S.activeFarm) return;
  const lbl = document.getElementById('activeFarmLabel');
  if (lbl) lbl.textContent = S.activeFarm.name;
  S.soilType = S.soilType || S.activeFarm.soil;
  renderDrawerFarms();
  renderFarmModalList();
}

function renderDrawerFarms() {
  const el = document.getElementById('drawerFarmList'); if (!el) return;
  el.innerHTML = (S.farms||[]).map(f => `
    <div class="drawer-farm-item ${S.activeFarm?.id===f.id?'active':''}" onclick="switchFarm('${f.id}')">
      <div class="dfi-ico">🏡</div>
      <div><div class="dfi-name">${f.name}</div><div class="dfi-loc">📍 ${f.location}</div></div>
    </div>`).join('');
}

function renderFarmModalList() {
  const el = document.getElementById('farmModalList'); if (!el) return;
  el.innerHTML = (S.farms||[]).map(f => `
    <div class="fm-item ${S.activeFarm?.id===f.id?'active':''}" onclick="switchFarm('${f.id}')">
      <div class="fm-item-ico">🏡</div>
      <div class="fm-item-body">
        <div class="fm-item-name">${f.name}</div>
        <div class="fm-item-loc">📍 ${f.location} · ${f.area} acres · ${f.soil}</div>
        ${f.activeCrop?`<div class="fm-item-loc">🌱 Active: ${f.activeCrop}</div>`:''}
      </div>
      ${S.activeFarm?.id===f.id?'<span class="fm-item-badge">Active</span>':''}
    </div>`).join('');
}

function switchFarm(id) {
  S.activeFarm = S.farms.find(f=>f.id===id);
  S.soilType = S.activeFarm.soil;
  if (S.activeFarm.activeCrop) S.selectedCrop = S.activeFarm.activeCrop;
  save(); updateActiveFarmUI();
  closeFarmModal(); closeDrawer();
  updateDashboardKpis();
  toast(`🏡 Switched to ${S.activeFarm.name}`, 'info');
  fetchWeatherForecast();
}

function addFarm() {
  const name = document.getElementById('fnName').value.trim();
  const loc  = document.getElementById('fnLoc').value.trim()||'India';
  const area = parseInt(document.getElementById('fnArea').value||5);
  const soil = document.getElementById('fnSoil').value||'loamy';
  if (!name) { toast('Enter a farm name', 'error'); return; }
  const farm = { id:'f'+Date.now(), name, location:loc, area, soil, activeCrop:null };
  S.farms.push(farm); save(); switchFarm(farm.id);
  toast(`🏡 Farm "${name}" added!`, 'success');
}

function openFarmModal()  { document.getElementById('farmModal').style.display='flex'; renderFarmModalList(); }
function closeFarmModal() { hide('farmModal'); }
function toggleAddFarm()  { const el=document.getElementById('addFarmInner'); el.style.display=el.style.display==='none'?'block':'none'; }

/* ═══════ DRAWER ═══════ */
function openDrawer()  { document.getElementById('farmDrawer').classList.add('open'); document.getElementById('drawerOverlay').classList.add('show'); }
function closeDrawer() { document.getElementById('farmDrawer').classList.remove('open'); document.getElementById('drawerOverlay').classList.remove('show'); }

/* ═══════ PROFILE / NOTIF DROPDOWNS ═══════ */
function toggleProfile() {
  const d = document.getElementById('profileDropdown');
  const n = document.getElementById('notifDropdown');
  hide('notifDropdown');
  d.style.display = d.style.display === 'none' ? 'block' : 'none';
}
function toggleNotif() {
  const d = document.getElementById('notifDropdown');
  hide('profileDropdown');
  d.style.display = d.style.display === 'none' ? 'block' : 'none';
}
document.addEventListener('click', e => {
  if (!e.target.closest('.profile-wrap')) hide('profileDropdown');
  if (!e.target.closest('.notif-wrap'))   hide('notifDropdown');
  if (!e.target.closest('.farm-modal') && !e.target.closest('.farm-badge')) {
    if (document.getElementById('farmModal').style.display === 'flex' &&
        !e.target.closest('.farm-badge')) {
      // don't auto close farm modal on outside click to be safe
    }
  }
});

/* ═══════ NAVIGATION ═══════ */
function goTo(page) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.bn-item').forEach(b => b.classList.remove('active'));
  const pageEl = document.getElementById(`page-${page}`);
  if (pageEl) { pageEl.classList.add('active'); window.scrollTo({top:0,behavior:'smooth'}); }
  const bnEl = document.getElementById(`bn-${page}`);
  if (bnEl) bnEl.classList.add('active');
  closeDrawer();
  // Page-specific
  if (page === 'dashboard') { updateDashboardKpis(); if(S.sensorData) refreshDashSensors(); }
  if (page === 'maintenance') {
    if (S.selectedCrop) renderMaintenanceFull();
    else renderWeatherBanners();
  }
  if (page === 'disease') buildDiseaseCatalogue();
}

/* ═══════ IMAGE UPLOAD ═══════ */
function previewImg(input, previewId, zoneId) {
  if (!input.files[0]) return;
  const reader = new FileReader();
  reader.onload = e => {
    const img = document.getElementById(previewId);
    img.src = e.target.result;
    img.style.display = 'block';
    const idleId = zoneId === 'soilZone' ? 'soilUploadIdle' : 'leafUploadIdle';
    hide(idleId);
  };
  reader.readAsDataURL(input.files[0]);
}

function handleDrop(ev, inputId, previewId) {
  ev.preventDefault(); ev.currentTarget.classList.remove('drag');
  const file = ev.dataTransfer.files[0]; if (!file) return;
  const dt = new DataTransfer(); dt.items.add(file);
  const inp = document.getElementById(inputId);
  inp.files = dt.files;
  previewImg(inp, previewId, inputId.replace('FileInput','Zone'));
}

/* ═══════════════════════════════════════════════
   STEP 1: SOIL ANALYSIS
═══════════════════════════════════════════════ */
function runSoilAnalysis() {
  const sample = document.getElementById('soilDemoSel').value;
  const file   = document.getElementById('soilFileInput').files[0];
  if (!sample && !file) { toast('Upload a soil image or select a demo soil type', 'warning'); return; }
  const type = sample || ['loamy','sandy','clay','silty'][Math.floor(Math.random()*4)];
  // Show step 2
  showBlock('recStep2');
  document.getElementById('recStep2').scrollIntoView({behavior:'smooth', block:'start'});
  // Show spinner
  show('sensorFetchStatus');
  hide('sensorReadingsBox');
  hide('sensorTs');
  hide('step2Actions');
  // Render soil result
  renderSoilResult(type);
  // Auto-fetch sensors after brief delay
  setTimeout(() => autoFetchSensors(type), 1200);
}

function quickSoil(type) {
  document.getElementById('soilDemoSel').value = type;
  runSoilAnalysis();
}

function renderSoilResult(type) {
  const d = SOIL_DB[type]; if (!d) return;
  S.soilType = type;
  if (S.activeFarm) S.activeFarm.soil = type;
  save();
  const tags = d.crops.map(c=>`<span class="tag-chip">🌱 ${c}</span>`).join('');
  setHTML('soilResultBox', `
    <div style="background:${d.bg};border-radius:10px;padding:14px;margin-bottom:12px;border:1px solid ${d.color}30">
      <div style="display:flex;align-items:center;gap:12px;margin-bottom:10px">
        <div style="width:52px;height:52px;border-radius:12px;background:${d.color}20;display:flex;align-items:center;justify-content:center;font-size:1.8rem;flex-shrink:0">${d.emoji}</div>
        <div>
          <div style="font-size:.7rem;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:.06em">CNN Classification · ResNet-50</div>
          <div style="font-size:1.2rem;font-weight:800;margin:2px 0">${d.label}</div>
          <div style="font-size:.8rem;color:var(--muted)">Confidence: <strong>${d.confidence}%</strong></div>
        </div>
      </div>
      <div class="prop-grid">
        <div class="prop-item"><span class="prop-k">pH Range</span><strong class="prop-v">${d.ph}</strong></div>
        <div class="prop-item"><span class="prop-k">Drainage</span><strong class="prop-v">${d.drainage}</strong></div>
        <div class="prop-item"><span class="prop-k">Nutrients</span><strong class="prop-v">${d.nutrients}</strong></div>
        <div class="prop-item"><span class="prop-k">Moisture</span><strong class="prop-v">${d.moisture}</strong></div>
      </div>
    </div>
    <div style="font-size:.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:6px">SUITABLE CROPS FOR THIS SOIL</div>
    <div class="tag-row">${tags}</div>
    <div class="tip-box" style="margin-top:12px">💡 <strong>Amendment:</strong> ${d.amendments}</div>
  `);
  toast(`✅ Soil classified as ${d.label} (${d.confidence}%)`, 'success');
}

/* ═══════════════════════════════════════════════
   STEP 2: IoT SENSOR AUTO-FETCH
═══════════════════════════════════════════════ */
function autoFetchSensors(soilOverride) {
  const soil = soilOverride || S.soilType || S.activeFarm?.soil || 'loamy';
  const profiles = {
    loamy:{N:[58,95], P:[32,68], K:[38,78], temp:[22,31],hum:[52,78],moist:[42,68]},
    sandy:{N:[25,48], P:[18,42], K:[28,58], temp:[28,37],hum:[14,38],moist:[16,40]},
    clay: {N:[55,85], P:[38,68], K:[42,72], temp:[22,31],hum:[52,78],moist:[48,72]},
    silty:{N:[68,105],P:[48,82], K:[32,68], temp:[20,29],hum:[62,88],moist:[55,80]},
  };
  const p = profiles[soil] || profiles.loamy;
  S.sensorData = {
    N: rnd(...p.N), P: rnd(...p.P), K: rnd(...p.K),
    temp: rndF(...p.temp), humidity: rnd(...p.hum), moisture: rnd(...p.moist),
    soilType: soil, ts: new Date().toISOString()
  };
  save();
  // Show readings
  hide('sensorFetchStatus');
  show('sensorReadingsBox');
  show('sensorTs');
  renderSensorReadingsInStep2();
  show('step2Actions');
  refreshDashSensors();
  updateDashboardKpis();
  generateAlerts();
  toast('✅ Live sensor data auto-fetched from IoT nodes', 'success');
}

function renderSensorReadingsInStep2() {
  const s = S.sensorData; if (!s) return;
  const rows = [
    ['🧪','N – Nitrogen',  s.N,  60,120,'kg/ha'],
    ['⚗️','P – Phosphorus',s.P,  25,80, 'kg/ha'],
    ['🔬','K – Potassium', s.K,  30,80, 'kg/ha'],
    ['🌡️','Temperature',   s.temp,18,34,'°C'],
    ['🌫️','Humidity',      s.humidity,40,82,'%'],
    ['💧','Soil Moisture',  s.moisture,35,75,'%'],
  ];
  setHTML('sensorReadingsBox', rows.map(([ico,lbl,v,lo,hi,unit]) => {
    const ok = v>=lo && v<=hi;
    const st = ok ? 'ok' : v < lo*0.65 ? 'bad' : 'warn';
    const stLbl = ok ? '✅ Normal' : st==='bad' ? '🔴 Critical' : '⚠️ Warning';
    return `
      <div class="srg-item ${st==='ok'?'':'abnormal'}">
        <div class="srg-ico">${ico}</div>
        <div class="srg-body">
          <div class="srg-label">${lbl}</div>
          <div class="srg-val">${v} <small style="font-size:.7rem;font-weight:400">${unit}</small></div>
          <div class="srg-status ${st}">${stLbl}</div>
        </div>
      </div>`;
  }).join(''));
  setHTML('sensorTs', `📡 Last fetched: ${new Date().toLocaleTimeString()} · Auto-updates every hour`);
  document.getElementById('sensorTs').style.display = 'block';
  document.getElementById('sensorReadingsBox').style.display = 'grid';
}

function resetSoilScan() {
  hide('recStep2');
  hide('recStep3');
  document.getElementById('soilDemoSel').value = '';
  document.getElementById('soilImgPreview').style.display = 'none';
  show('soilUploadIdle');
}

/* ═══════════════════════════════════════════════
   STEP 3: CROP RECOMMENDATION ENGINE
═══════════════════════════════════════════════ */
function scoreCrop(name, s) {
  const d = CROP_DB[name]; if (!d) return -999;
  const soilOk = d.soil.includes(s.soilType) ? 15 : 3;
  const rs = (v,lo,hi,pts) => {
    if (v>=lo&&v<=hi) return pts;
    return Math.max(0, pts*(1-(Math.min(Math.abs(v-lo),Math.abs(v-hi))/Math.max(hi-lo,1))*1.5));
  };
  return soilOk + rs(s.N,...d.N,12) + rs(s.P,...d.P,10) + rs(s.K,...d.K,10)
       + rs(s.temp,...d.temp,8) + rs(s.humidity,...d.hum,6) + rs(s.moisture,...d.moisture,6);
}

function getTopCrops(n=5) {
  if (!S.sensorData) return [];
  const seen = new Set();
  return Object.keys(CROP_DB)
    .filter(k => { if(seen.has(k)) return false; seen.add(k); return true; })
    .map(name => ({ name, score: scoreCrop(name, S.sensorData) }))
    .sort((a,b) => b.score-a.score)
    .slice(0, n)
    .map((c,i) => ({ ...c, rank:i+1, confidence: Math.min(99, Math.round((c.score/67)*100)) }));
}

function runRecommendation() {
  showBlock('recStep3');
  document.getElementById('recStep3').scrollIntoView({behavior:'smooth', block:'start'});
  showBlock('recLoadingBox');
  hide('cropCardsGrid');
  hide('recChartsRow');
  // Context bar
  const s = S.sensorData;
  const soil = SOIL_DB[S.soilType];
  setHTML('recContextBar', `
    <span>📊</span>
    <span>Analysis based on: <strong>${soil?.label||S.soilType||'Detected Soil'}</strong> · N:<strong>${s?.N||'—'}</strong> · P:<strong>${s?.P||'—'}</strong> · K:<strong>${s?.K||'—'}</strong> · T:<strong>${s?.temp||'—'}°C</strong> · H:<strong>${s?.humidity||'—'}%</strong> · M:<strong>${s?.moisture||'—'}%</strong></span>
  `);
  setTimeout(() => {
    hide('recLoadingBox');
    const tops = getTopCrops(5);
    const grid = document.getElementById('cropCardsGrid');
    grid.innerHTML = tops.map(c => renderCropCard(c)).join('');
    grid.style.display = 'grid';
    if (S.selectedCrop) markSelectedCard();
    // Charts
    showBlock('recChartsRow');
    setTimeout(() => buildRecCharts(tops), 150);
  }, 2000);
}

function renderCropCard(c) {
  const d = CROP_DB[c.name]; if (!d) return '';
  const isSelected = S.selectedCrop === c.name;
  const diseases = Object.values(DISEASE_DB).filter(x=>x.crop===c.name&&x.disease!=='Healthy').slice(0,2);
  const barColor = c.confidence > 80 ? 'var(--g2)' : c.confidence > 60 ? 'var(--a3)' : 'var(--r2)';
  return `
    <div class="crop-card ${isSelected?'selected':''}" id="cc_${c.name.replace(/\s/g,'_')}">
      <div class="cc-top">
        <div class="cc-emoji">${d.emoji}</div>
        <div class="cc-info">
          <div class="cc-rank">#${c.rank} Best Match</div>
          <div class="cc-name">${c.name}</div>
          <div class="cc-season">📅 ${d.season} · ${d.growDays||90} days to harvest</div>
        </div>
        <div class="cc-score-wrap">
          <div class="cc-pct" style="color:${barColor}">${c.confidence}%</div>
          <div class="cc-match">Match</div>
        </div>
      </div>
      <div class="cc-bar-wrap"><div class="cc-bar" style="width:${c.confidence}%;background:${barColor}"></div></div>
      <div class="cc-props">
        <div class="cc-prop"><span class="cc-prop-k">Soil Type</span><span class="cc-prop-v">${d.soil.join(', ')}</span></div>
        <div class="cc-prop"><span class="cc-prop-k">Yield</span><span class="cc-prop-v">${d.yieldTha||'—'} t/ha</span></div>
        <div class="cc-prop"><span class="cc-prop-k">Water Need</span><span class="cc-prop-v">${d.waterReq||'Medium'}</span></div>
        <div class="cc-prop"><span class="cc-prop-k">Fertilizer</span><span class="cc-prop-v">${d.fertReq||'Medium'}</span></div>
        ${diseases.length ? `<div class="cc-prop" style="grid-column:span 2"><span class="cc-prop-k">⚠️ Disease Risk</span><span class="cc-prop-v" style="color:var(--r1)">${diseases.map(x=>x.disease).join(', ')}</span></div>` : ''}
      </div>
      <div class="cc-footer">
        <button class="btn-select ${isSelected?'selected-state':''}" onclick="selectCrop('${c.name}')">
          ${isSelected ? '✅ Selected' : '🌱 Select This Crop'}
        </button>
        <button class="btn-detail" onclick="showCropDetail('${c.name}')">ℹ️ Details</button>
      </div>
    </div>`;
}

function markSelectedCard() {
  document.querySelectorAll('.crop-card').forEach(c => c.classList.remove('selected'));
  document.querySelectorAll('.btn-select').forEach(b => { b.classList.remove('selected-state'); b.textContent='🌱 Select This Crop'; });
  if (!S.selectedCrop) return;
  const card = document.getElementById(`cc_${S.selectedCrop.replace(/\s/g,'_')}`);
  if (card) {
    card.classList.add('selected');
    const btn = card.querySelector('.btn-select');
    if (btn) { btn.classList.add('selected-state'); btn.textContent='✅ Selected'; }
  }
}

function selectCrop(name) {
  S.selectedCrop = name;
  S.cropStartDate = new Date().toISOString();
  if (S.activeFarm) S.activeFarm.activeCrop = name;
  save(); markSelectedCard(); updateDashboardKpis();
  addNotif('ok','🌱 Crop Selected', `${name} added to Maintenance. Monitoring started.`, 'Just now');
  toast(`✅ ${name} selected! Opening Maintenance…`, 'success');
  setTimeout(() => { goTo('maintenance'); renderMaintenanceFull(); }, 1600);
}

function showCropDetail(name) {
  const d = CROP_DB[name]; if (!d) return;
  const s = S.sensorData;
  const conf = s ? Math.min(99, Math.round((scoreCrop(name, s)/67)*100)) : '—';
  
  // Calculate Weather Suitability HTML
  const w = S.weatherOutlook;
  let weatherSuitabilityHtml = '';
  if (w) {
    const waterReq = d.waterReq || 'Medium';
    let statusClass = 'mod';
    let suitabilityLabel = 'Suitable';
    let suitabilityDesc = '';
    
    if (w.outlook === 'wet') {
      if (waterReq === 'High') {
        statusClass = 'good';
        suitabilityLabel = 'Highly Suitable';
        suitabilityDesc = `The upcoming wet period (${w.maxRainProb}% max rain probability) matches this crop's high water requirements perfectly, minimizing manual watering.`;
      } else if (waterReq === 'Low') {
        statusClass = 'bad';
        suitabilityLabel = 'Not Suitable';
        suitabilityDesc = `Heavy rains forecasted are risky. This crop requires low moisture; excess rain can cause root rot or soil waterlogging.`;
      } else {
        statusClass = 'mod';
        suitabilityLabel = 'Moderately Suitable';
        suitabilityDesc = `Moderately suitable. Sowing is fine, but ensure the field is well-drained to manage heavy rains.`;
      }
    } else if (w.outlook === 'dry') {
      if (waterReq === 'Low') {
        statusClass = 'good';
        suitabilityLabel = 'Highly Suitable';
        suitabilityDesc = `Forecast is dry (Max rain: ${w.maxRainProb}%). This crop is drought-tolerant and requires minimal water, making it excellent to grow now.`;
      } else if (waterReq === 'High') {
        statusClass = 'bad';
        suitabilityLabel = 'Not Suitable';
        suitabilityDesc = `High water demand crop. The forecasted dry period will require excessive irrigation, which might not be resource-sustainable.`;
      } else {
        statusClass = 'mod';
        suitabilityLabel = 'Moderately Suitable';
        suitabilityDesc = `Moderately suitable. You will need to irrigate systematically and use mulching to preserve moisture.`;
      }
    } else {
      suitabilityDesc = `Moderate/normal conditions are forecasted. Standard water management rules apply.`;
    }
    
    weatherSuitabilityHtml = `
      <div style="background:#f0fdf4;border:1px solid var(--border);border-radius:10px;padding:12px;margin-bottom:10px">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
          <span style="font-size:.7rem;font-weight:800;color:var(--g1);text-transform:uppercase;letter-spacing:0.04em">🌤️ Weather Suitability</span>
          <span class="suit-badge ${statusClass}">${suitabilityLabel}</span>
        </div>
        <div style="font-size:.82rem;color:var(--text2);line-height:1.5">
          <strong>Forecast for ${w.displayName}:</strong> ${suitabilityDesc}
        </div>
      </div>`;
  }

  const modal = document.createElement('div');
  modal.style.cssText='position:fixed;inset:0;z-index:3000;background:rgba(0,0,0,.6);display:flex;align-items:center;justify-content:center;padding:16px';
  modal.innerHTML = `
    <div style="background:#fff;border-radius:20px;width:100%;max-width:520px;max-height:88vh;overflow-y:auto;box-shadow:0 32px 80px rgba(0,0,0,.3)">
      <div style="display:flex;align-items:center;gap:14px;padding:20px 24px;border-bottom:1px solid var(--border)">
        <span style="font-size:3rem">${d.emoji}</span>
        <div style="flex:1"><h2 style="font-size:1.4rem;font-weight:800;margin-bottom:4px">${name}</h2><p style="color:var(--muted);font-size:.85rem">${d.season} Season · ${d.growDays||90} days to harvest</p></div>
        <button onclick="this.closest('[style*=fixed]').remove()" style="background:none;border:none;font-size:1.5rem;cursor:pointer;color:var(--muted);padding:4px">✕</button>
      </div>
      <div style="padding:20px 24px">
        <div class="prop-grid" style="margin-bottom:16px">
          <div class="prop-item"><span class="prop-k">AI Match</span><strong class="prop-v" style="color:var(--g2)">${conf}%</strong></div>
          <div class="prop-item"><span class="prop-k">Yield</span><strong class="prop-v">${d.yieldTha||'—'} t/ha</strong></div>
          <div class="prop-item"><span class="prop-k">Season</span><strong class="prop-v">${d.season}</strong></div>
          <div class="prop-item"><span class="prop-k">Grow Days</span><strong class="prop-v">${d.growDays||90}</strong></div>
          <div class="prop-item"><span class="prop-k">Water Need</span><strong class="prop-v">${d.waterReq||'Medium'}</strong></div>
          <div class="prop-item"><span class="prop-k">Fertilizer</span><strong class="prop-v">${d.fertReq||'Medium'}</strong></div>
        </div>
        ${weatherSuitabilityHtml}
        <div style="background:#f8fafc;border-radius:10px;padding:13px;margin-bottom:10px">
          <div style="font-size:.7rem;font-weight:800;color:var(--muted);text-transform:uppercase;margin-bottom:6px">💧 IRRIGATION</div>
          <div style="font-size:.85rem;color:var(--text2);line-height:1.6">${d.irrigation}</div>
        </div>
        <div style="background:#f8fafc;border-radius:10px;padding:13px;margin-bottom:10px">
          <div style="font-size:.7rem;font-weight:800;color:var(--muted);text-transform:uppercase;margin-bottom:6px">🧪 FERTILIZER</div>
          <div style="font-size:.85rem;color:var(--text2);line-height:1.6">${d.fertilizer}</div>
        </div>
        <div style="background:var(--g6);border-radius:10px;padding:13px;margin-bottom:16px">
          <div style="font-size:.7rem;font-weight:800;color:var(--g1);text-transform:uppercase;margin-bottom:6px">💡 PRO TIPS</div>
          <div style="font-size:.85rem;color:#166534;line-height:1.6">${d.tips}</div>
        </div>
        <button class="btn-primary w100" onclick="selectCrop('${name}');this.closest('[style*=fixed]').remove()">🌱 Select This Crop →</button>
      </div>
    </div>`;
  document.body.appendChild(modal);
  modal.addEventListener('click', e => { if(e.target===modal) modal.remove(); });
}

function buildRecCharts(tops) {
  // Disease risk bar
  const dCtx = document.getElementById('recDiseaseBar'); if (!dCtx) return;
  if (S.charts.recDis) S.charts.recDis.destroy();
  const topDis = Object.values(DISEASE_DB).filter(d=>d.disease!=='Healthy').sort((a,b)=>b.confidence-a.confidence).slice(0,8);
  S.charts.recDis = new Chart(dCtx, {
    type:'bar',
    data:{ labels: topDis.map(d=>d.disease), datasets:[{ label:'Risk %',
      data:topDis.map(d=>d.confidence),
      backgroundColor:topDis.map(d=>d.severity==='CRITICAL'?'rgba(220,38,38,.7)':d.severity==='HIGH'?'rgba(239,68,68,.6)':'rgba(245,158,11,.6)'),
      borderRadius:5 }] },
    options:{ indexAxis:'y', plugins:{legend:{display:false}}, scales:{x:{max:100}} }
  });
  // Success pie
  const pCtx = document.getElementById('recSuccessPie'); if (!pCtx) return;
  if (S.charts.recPie) S.charts.recPie.destroy();
  S.charts.recPie = new Chart(pCtx, {
    type:'doughnut',
    data:{ labels: tops.map(c=>c.name), datasets:[{ data: tops.map(c=>c.confidence),
      backgroundColor:['#22c55e','#3b82f6','#f59e0b','#8b5cf6','#06b6d4'],
      borderWidth:2 }] },
    options:{ plugins:{ legend:{ position:'right', labels:{ font:{size:10} } } }, cutout:'55%' }
  });
}

/* ═══════════════════════════════════════════════
   CROP MAINTENANCE
═══════════════════════════════════════════════ */
function renderMaintenanceFull() {
  if (!S.selectedCrop) return;
  const name = S.selectedCrop;
  const d = CROP_DB[name]; if (!d) return;
  const start  = S.cropStartDate ? new Date(S.cropStartDate) : new Date();
  const elapsed = Math.max(0, Math.floor((new Date()-start)/86400000));
  const growDays = d.growDays || 90;
  const daysLeft = Math.max(0, growDays - elapsed);
  const progress = Math.min(100, Math.round((elapsed/growDays)*100));
  const s = S.sensorData;
  let health = computeHealth();
  const healthScore = health ? health.score : 82;
  const healthLabel = health ? health.label : '✅ Good';

  setHTML('maintenanceContent', `
    <!-- Hero -->
    <div class="maint-hero">
      <div class="mh-emoji">${d.emoji}</div>
      <div class="mh-info">
        <div class="mh-label">Active Crop · ${S.activeFarm?.name||'My Farm'}</div>
        <div class="mh-crop">${name}</div>
        <div class="mh-days">📅 Day ${elapsed} of ${growDays} · ${daysLeft} days remaining · ${d.season} Season</div>
        <div class="mh-progress"><div class="mh-prog-fill" style="width:${progress}%"></div></div>
        <div class="mh-prog-label">${progress}% complete</div>
      </div>
      <div class="mh-score"><div class="mh-score-val">${healthScore}%</div><div class="mh-score-lbl">Health Score</div><div style="font-size:.8rem;margin-top:4px">${healthLabel}</div></div>
    </div>

    <!-- Yield control -->
    <div class="yield-ctrl">
      <div class="yc-title">🌾 Yield Completion Control</div>
      <div class="yc-sub">Has your ${name} crop been harvested? Tap YES to stop monitoring.</div>
      <div class="yc-btns">
        <button class="btn-yc-yes" onclick="confirmHarvest()">✅ Yes — Yield Completed</button>
        <button class="btn-yc-no"  onclick="toast('Continuing monitoring…','info')">🔄 No — Continue</button>
      </div>
    </div>

    <!-- 3-col grid -->
    <div class="maint-grid-3">
      <!-- Live Sensor -->
      <div class="card">
        <div class="card-hdr">📡 Live Sensor Data <span style="background:var(--g2);color:#fff;font-size:.62rem;font-weight:700;padding:2px 7px;border-radius:12px;margin-left:auto;animation:pulse 2s infinite">● LIVE</span></div>
        <div class="card-body">
          ${s ? buildSensorMini(s, d) : '<p style="color:var(--muted);font-size:.85rem">No data — <button class="btn-primary" style="padding:6px 12px;font-size:.78rem" onclick="autoFetchSensors();renderMaintenanceFull()">Fetch Now</button></p>'}
          <div style="font-size:.7rem;color:var(--muted);margin-top:8px">Auto-updates every hour</div>
          <button class="btn-secondary" style="width:100%;margin-top:10px;padding:8px" onclick="autoFetchSensors();setTimeout(renderMaintenanceFull,800)">⚡ Refresh Sensors</button>
        </div>
      </div>
      <!-- Irrigation -->
      <div class="card">
        <div class="card-hdr">💧 Irrigation Schedule</div>
        <div class="card-body">${buildIrrigationSchedule(name, s?.moisture||55)}</div>
      </div>
      <!-- Status -->
      <div class="card">
        <div class="card-hdr">📊 Maintenance Status</div>
        <div class="card-body">${buildStatusChecklist(s, d)}</div>
      </div>
    </div>

    <!-- Fertilizer -->
    <div class="card mt16">
      <div class="card-hdr">🌿 Fertilizer Schedule</div>
      <div class="card-body">
        <div style="background:#f8fafc;border-radius:10px;padding:12px;margin-bottom:12px;font-size:.85rem;color:var(--text2);line-height:1.6"><strong>Plan:</strong> ${d.fertilizer}</div>
        ${FERT_SCHEDULE.map(f=>`
          <div class="fert-stage">
            <div class="fs-ico">${f.icon}</div>
            <div><div class="fs-day">${f.day}</div><div class="fs-name">${f.name}</div><div class="fs-dose">${f.dose}</div></div>
          </div>`).join('')}
      </div>
    </div>

    <!-- Smart Alerts -->
    <div class="card mt16">
      <div class="card-hdr">🔔 Smart Alerts & Remedies</div>
      <div class="card-body">${buildAlertsList(s, name)}</div>
    </div>

    <!-- Disease Risk Chart (R) -->
    <div class="card mt16">
      <div class="card-hdr">📊 Disease Risk Analysis — ${name} <span class="r-tag">R / ggplot2</span></div>
      <div class="card-body">
        <p style="font-size:.82rem;color:var(--muted);margin-bottom:14px">Possible diseases for ${name} based on current conditions and historical dataset frequency analysis.</p>
        <canvas id="maintDiseaseChart" height="130"></canvas>
      </div>
    </div>
  `);
  setTimeout(() => buildMaintDiseaseChart(name), 200);
}

function buildSensorMini(s, d) {
  const rows = [
    ['🧪','N',s.N,   d.N[0], d.N[1], 'kg/ha'],
    ['⚗️','P',s.P,   d.P[0], d.P[1], 'kg/ha'],
    ['🔬','K',s.K,   d.K[0], d.K[1], 'kg/ha'],
    ['🌡️','Temp',s.temp, d.temp[0],d.temp[1],'°C'],
    ['🌫️','Humidity',s.humidity,40,82,'%'],
    ['💧','Moisture',s.moisture,35,75,'%'],
  ];
  return `<div style="display:grid;grid-template-columns:1fr 1fr;gap:7px">
    ${rows.map(([ico,lbl,v,lo,hi,u])=>{
      const ok=v>=lo&&v<=hi;
      return `<div style="padding:8px 10px;border-radius:8px;background:#f8fafc;border-left:3px solid ${ok?'var(--g3)':'var(--r2)'}">
        <div style="font-size:.65rem;color:var(--muted);font-weight:600">${ico} ${lbl}</div>
        <div style="font-weight:800;font-size:1rem;color:${ok?'var(--g1)':'var(--r1)'}">${v}<span style="font-size:.65rem;font-weight:400"> ${u}</span></div>
        <div style="font-size:.63rem;color:${ok?'var(--g2)':'var(--r2)'}">${ok?'✅ OK':'⚠️ Alert'}</div>
      </div>`;
    }).join('')}
  </div>`;
}

function buildIrrigationSchedule(name, moisture) {
  const freq = moisture < 35 ? 1 : moisture < 50 ? 2 : 3;
  const labels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
  const waterDays = freq===1?[0,1,2,3,4,5,6]:freq===2?[0,2,4,6]:[0,3,6];
  const todayIdx = (new Date().getDay()+6)%7;
  const freqLabel = ['Daily','Every 2 Days','Every 3 Days'][freq-1];
  
  // Rain skip logic
  const w = S.weatherOutlook;
  let rainSkipHtml = '';
  
  if (w && w.todayRainProb >= 60) {
    const isWateringToday = waterDays.includes(todayIdx);
    if (isWateringToday) {
      rainSkipHtml = `
        <div style="margin-top: 10px; background: var(--r4); border: 1.5px solid var(--r2); color: var(--r1); border-radius: 8px; padding: 10px; font-size: 0.8rem; font-weight: 700; display: flex; align-items: center; gap: 8px;">
          <span>🌧️</span>
          <div>Smart Skip: Today is a watering day, but forecast predicts a ${w.todayRainProb}% chance of rain. Skip irrigation today to save water and prevent waterlogging.</div>
        </div>`;
    } else {
      rainSkipHtml = `
        <div style="margin-top: 10px; background: var(--b4); border: 1.5px solid var(--b3); color: var(--b1); border-radius: 8px; padding: 10px; font-size: 0.8rem; font-weight: 600; display: flex; align-items: center; gap: 8px;">
          <span>🌧️</span>
          <div>Rain expected today (${w.todayRainProb}% probability). Monitor field drainage.</div>
        </div>`;
    }
  }

  return `
    <div style="margin-bottom:10px;font-size:.85rem">Frequency: <strong style="color:var(--g2)">${freqLabel}</strong>
      ${moisture<35?'<span style="color:var(--r2);font-size:.76rem;margin-left:6px">⚠️ Critical moisture!</span>':''}
    </div>
    <div class="irrig-row">
      ${labels.map((day,i)=>{
        const isW=waterDays.includes(i), isT=i===todayIdx;
        return `<div class="ir-day ${isW?'water':''} ${isT?'today':''}">
          <span class="ir-ico">${isW?'💧':'☀️'}</span>
          <strong>${day}</strong>
          ${isT?'<div style="color:var(--g2);font-size:.6rem">Today</div>':''}
          ${isW?'<div style="color:var(--b1);font-size:.6rem">Water</div>':''}
        </div>`;
      }).join('')}
    </div>
    ${rainSkipHtml}
    <div class="tip-box" style="margin-top:10px;font-size:.79rem">${CROP_DB[name]?.irrigation||'Follow recommended schedule'}</div>`;
}

function buildStatusChecklist(s, d) {
  if (!s) return '<p style="color:var(--muted);font-size:.85rem">Awaiting sensor data…</p>';
  const checks = [
    {lbl:'Moisture',  ok:s.moisture>=35&&s.moisture<=75,  v:s.moisture+'%'},
    {lbl:'Temperature',ok:s.temp>=d.temp[0]&&s.temp<=d.temp[1],v:s.temp+'°C'},
    {lbl:'Humidity',  ok:s.humidity>=40&&s.humidity<=85,  v:s.humidity+'%'},
    {lbl:'Nitrogen',  ok:s.N>=d.N[0]&&s.N<=d.N[1],       v:s.N+' kg/ha'},
    {lbl:'Phosphorus',ok:s.P>=d.P[0]&&s.P<=d.P[1],       v:s.P+' kg/ha'},
    {lbl:'Potassium', ok:s.K>=d.K[0]&&s.K<=d.K[1],       v:s.K+' kg/ha'},
  ];
  const overallOk = checks.every(c=>c.ok);
  const overallMod = checks.filter(c=>c.ok).length >= 4;
  return `
    <div class="status-bar ${overallOk?'good':overallMod?'moderate':'bad'}" style="margin-bottom:12px">
      <span style="font-size:1.2rem">${overallOk?'✅':overallMod?'⚠️':'🔴'}</span>
      <strong>${overallOk?'Good Condition':overallMod?'Moderate — monitor closely':'Poor — immediate action needed'}</strong>
    </div>
    ${checks.map(c=>`
      <div style="display:flex;justify-content:space-between;align-items:center;padding:7px 0;border-bottom:1px solid var(--border2)">
        <span style="font-size:.83rem;color:var(--text2)">${c.lbl}</span>
        <span style="display:flex;align-items:center;gap:7px">
          <strong style="font-size:.85rem">${c.v}</strong>
          <span style="padding:2px 9px;border-radius:12px;font-size:.68rem;font-weight:700;background:${c.ok?'var(--g5)':'var(--r4)'};color:${c.ok?'var(--g1)':'var(--r1)'}">${c.ok?'✅ OK':'⚠️ Alert'}</span>
        </span>
      </div>`).join('')}`;
}

function buildAlertsList(s, cropName) {
  if (!s) return '<p style="color:var(--muted)">Awaiting sensor data…</p>';
  const triggered = [];
  if (s.moisture < 35) triggered.push('low_moisture');
  if (s.temp > 35)     triggered.push('high_temp');
  if (s.N < 25)        triggered.push('low_nitrogen');
  if (s.K < 25)        triggered.push('low_potassium');
  if (s.humidity > 82) triggered.push('high_humidity');
  if (s.P < 15)        triggered.push('low_phosphorus');
  if (!triggered.length) return `
    <div class="alert-item ok">
      <div class="ai-ico">✅</div>
      <div class="ai-body">
        <div class="ai-title">All Conditions Optimal</div>
        <div class="ai-msg">All sensor values are within ideal range for ${cropName}. Continue current farming practices.</div>
        <div class="ai-remedy"><strong>💡 Recommendation:</strong> Keep monitoring. Check again after next irrigation cycle.</div>
      </div>
      <span class="ai-badge badge-ok">GOOD</span>
    </div>`;
  return triggered.map(k => {
    const a = ALERT_TEMPLATES[k];
    return `
      <div class="alert-item ${a.type}">
        <div class="ai-ico">${a.ico}</div>
        <div class="ai-body">
          <div class="ai-title">${a.title}</div>
          <div class="ai-msg">Detected from IoT sensor data · ${new Date().toLocaleTimeString()}</div>
          <div class="ai-remedy"><strong>💊 Immediate Action:</strong><br>${a.remedy}</div>
          <div class="ai-prev"><strong>🛡️ Preventive Measure:</strong><br>${a.prevention}</div>
        </div>
        <span class="ai-badge ${a.type==='crit'?'badge-crit':a.type==='warn'?'badge-warn':'badge-info'}">${a.badge}</span>
      </div>`;
  }).join('');
}

function buildMaintDiseaseChart(name) {
  const ctx = document.getElementById('maintDiseaseChart'); if (!ctx) return;
  if (S.charts.maintD) S.charts.maintD.destroy();
  const items = Object.values(DISEASE_DB).filter(d=>d.crop===name&&d.disease!=='Healthy');
  if (!items.length) return;
  S.charts.maintD = new Chart(ctx, {
    type:'bar',
    data:{ labels:items.map(d=>d.disease), datasets:[{ label:'Risk %', data:items.map(d=>Math.round(d.curePct+d.managePct)),
      backgroundColor:items.map(d=>d.severity==='CRITICAL'?'rgba(220,38,38,.75)':d.severity==='HIGH'?'rgba(239,68,68,.6)':'rgba(245,158,11,.6)'),
      borderRadius:6 }] },
    options:{ plugins:{legend:{display:false}}, scales:{y:{max:100,title:{display:true,text:'Risk %'}}} }
  });
}

function computeHealth() {
  if (!S.sensorData) return null;
  const s = S.sensorData; let score = 100;
  if (s.moisture < 35) score -= 25; else if (s.moisture < 45) score -= 10;
  if (s.humidity > 85) score -= 15;
  if (s.temp > 38) score -= 20; else if (s.temp > 34) score -= 8;
  if (s.N < 20) score -= 15; if (s.P < 15) score -= 10; if (s.K < 20) score -= 10;
  if (score >= 75) return {label:'✅ Good',color:'var(--g2)',score};
  if (score >= 50) return {label:'⚠️ Moderate',color:'var(--a3)',score};
  return {label:'🔴 Poor',color:'var(--r2)',score};
}

function confirmHarvest() {
  if (!confirm(`Mark ${S.selectedCrop} harvest as complete?\nThis will stop monitoring.`)) return;
  const old = S.selectedCrop;
  S.selectedCrop = null; S.cropStartDate = null;
  if (S.activeFarm) S.activeFarm.activeCrop = null;
  save(); updateDashboardKpis();
  toast(`🎉 ${old} harvest complete! Great farming!`, 'success');
  addNotif('ok','🎉 Harvest Complete!',`${old} successfully harvested. Ready for next crop cycle.`,'Just now');
  setHTML('maintenanceContent', `
    <div style="text-align:center;padding:60px 20px;background:#fff;border-radius:var(--radius);box-shadow:var(--shadow)">
      <div style="font-size:5rem;margin-bottom:16px">🎉</div>
      <h2 style="font-size:1.6rem;font-weight:800;margin-bottom:10px">Harvest Complete!</h2>
      <p style="color:var(--muted);max-width:400px;margin:0 auto 24px;font-size:.9rem">${old} has been successfully harvested. Ready to start a new crop cycle?</p>
      <button class="btn-primary" onclick="goTo('recommendation')">🌱 Start New Crop Cycle →</button>
    </div>`);
}

/* ═══════════════════════════════════════════════
   DISEASE DETECTION
═══════════════════════════════════════════════ */
function detectDisease() {
  const demo = document.getElementById('diseaseDemo').value;
  const file = document.getElementById('leafFileInput').files[0];
  if (!demo && !file) { toast('Upload a leaf image or select a demo', 'warning'); return; }
  setHTML('diseaseResultBox', '<div class="loading-box"><div class="spinner"></div><p>Running MobileNetV2 CNN disease classifier…</p></div>');
  hide('diseaseChartsRow');
  const key = demo || Object.keys(DISEASE_DB)[Math.floor(Math.random()*Object.keys(DISEASE_DB).length)];
  setTimeout(() => { renderDiseaseResult(key); renderDiseaseCharts(key); }, 2200);
}

function renderDiseaseResult(key) {
  const d = DISEASE_DB[key]; if (!d) return;
  const isH = d.disease === 'Healthy';
  const sevC = {HEALTHY:'var(--g2)',LOW:'#84cc16',MODERATE:'var(--a3)',HIGH:'var(--r2)',CRITICAL:'#dc2626'};
  const sevCls = {HEALTHY:'sev-healthy',LOW:'sev-low',MODERATE:'sev-moderate',HIGH:'sev-high',CRITICAL:'sev-critical'};
  const col = sevC[d.severity] || 'var(--muted)';
  setHTML('diseaseResultBox', `
    <div class="dis-result-wrap">
      <div class="dis-res-top" style="background:${isH?'var(--g6)':'var(--r4)'}20">
        <div class="dis-res-ico" style="background:${col}20;color:${col}">${isH?'✅':'🦠'}</div>
        <div class="dis-res-info">
          <div class="dis-res-tag">Detection Result · ${d.crop}</div>
          <div class="dis-res-name">${d.disease}</div>
          <div class="dis-res-conf">Confidence: <strong>${d.confidence}%</strong></div>
        </div>
      </div>
      <div style="padding:12px 18px">
        <span class="sev-badge ${sevCls[d.severity]||'sev-moderate'}">${d.severity}</span>
        <div class="conf-bar"><div class="conf-fill" style="width:${d.confidence}%;background:${col}"></div></div>
      </div>
      <div class="dis-section">
        <div class="ds-label">💊 Treatment Steps</div>
        <ul class="ds-body">${d.remedy.map(r=>`<li style="margin-bottom:5px">${r}</li>`).join('')}</ul>
      </div>
      <div class="dis-section">
        <div class="ds-label">🧴 Pesticide / Chemical</div>
        <div class="ds-body">${d.pesticide}</div>
      </div>
      <div class="dis-section">
        <div class="ds-label">🌿 Fertilizer Advice</div>
        <div class="ds-body">${d.fertilizer}</div>
      </div>
      <div class="dis-section ds-green">
        <div class="ds-label" style="color:var(--g1)">🛡️ Prevention Strategy</div>
        <div class="ds-body" style="color:#166534">${d.prevention}</div>
      </div>
    </div>`);
  addNotif(isH?'ok':'crit',isH?'✅ Plant Healthy':`🦠 ${d.disease} Detected`,
    isH?'No disease found.': `${d.crop} — ${d.severity}. Apply: ${d.pesticide}`,'Just now');
}

function renderDiseaseCharts(key) {
  const d = DISEASE_DB[key]; if (!d) return;
  const row = document.getElementById('diseaseChartsRow');
  if (row) row.style.display = 'grid';
  // Cure Pie
  const cCtx = document.getElementById('curePieChart'); if (!cCtx) return;
  if (S.charts.curePie) S.charts.curePie.destroy();
  S.charts.curePie = new Chart(cCtx, {
    type:'doughnut',
    data:{ labels:['Curable','Manageable','Not Curable'],
      datasets:[{data:[d.curePct,d.managePct,d.noCurePct],backgroundColor:['#22c55e','#f59e0b','#ef4444'],borderWidth:2}] },
    options:{ plugins:{legend:{position:'bottom',labels:{font:{size:10}}}}, cutout:'60%' }
  });
  // Severity bar
  const sCtx = document.getElementById('severityBarChart'); if (!sCtx) return;
  if (S.charts.sevBar) S.charts.sevBar.destroy();
  const cropDis = Object.values(DISEASE_DB).filter(x=>x.crop===d.crop);
  S.charts.sevBar = new Chart(sCtx, {
    type:'bar',
    data:{ labels:cropDis.map(x=>x.disease), datasets:[{label:'Confidence %', data:cropDis.map(x=>x.confidence),
      backgroundColor:cropDis.map(x=>({HEALTHY:'#22c55e',MODERATE:'#f59e0b',HIGH:'#ef4444',CRITICAL:'#dc2626'}[x.severity]||'#6b7280')),
      borderRadius:5}] },
    options:{ plugins:{legend:{display:false}}, scales:{y:{max:100}} }
  });
  // Freq by crop
  const fCtx = document.getElementById('disFreqChart'); if (!fCtx) return;
  if (S.charts.freqC) S.charts.freqC.destroy();
  const byCrop = {};
  Object.values(DISEASE_DB).filter(x=>x.disease!=='Healthy').forEach(x=>{byCrop[x.crop]=(byCrop[x.crop]||0)+1;});
  const labs = Object.keys(byCrop).slice(0,10);
  S.charts.freqC = new Chart(fCtx, {
    type:'bar', data:{ labels:labs, datasets:[{label:'Diseases',data:labs.map(c=>byCrop[c]),backgroundColor:'var(--b2)',borderRadius:4}] },
    options:{ indexAxis:'y', plugins:{legend:{display:false}}, scales:{x:{title:{display:true,text:'# Classes'}}} }
  });
}

function buildDiseaseCatalogue() {
  const cat = document.getElementById('diseaseCatalogue'); if (!cat||cat.dataset.built==='1') return;
  const byCrop = {};
  Object.entries(DISEASE_DB).forEach(([k,d])=>{ if(!byCrop[d.crop]) byCrop[d.crop]=[]; byCrop[d.crop].push({key:k,...d}); });
  cat.innerHTML = Object.keys(byCrop).sort().map(crop => {
    const items = byCrop[crop];
    const em = items[0]?.emoji||'🌿';
    const tags = items.map(item => {
      const cls = item.disease==='Healthy'?'dct-healthy':item.severity==='CRITICAL'?'dct-critical':item.severity==='HIGH'?'dct-high':'dct-moderate';
      return `<span class="dct ${cls}">${item.disease}</span>`;
    }).join('');
    return `<div class="dc-item"><div class="dc-item-hdr">${em} <strong>${crop}</strong></div><div class="dc-tags">${tags}</div></div>`;
  }).join('');
  cat.dataset.built = '1';
}

/* ═══════════════════════════════════════════════
   DASHBOARD
═══════════════════════════════════════════════ */
function updateDashboardKpis() {
  const crop = S.selectedCrop;
  const h = computeHealth();
  const d = crop ? CROP_DB[crop] : null;
  const start = S.cropStartDate ? new Date(S.cropStartDate) : new Date();
  const elapsed = Math.max(0, Math.floor((new Date()-start)/86400000));
  const daysLeft = d ? Math.max(0,(d.growDays||90)-elapsed) : 0;

  const set = (id, v) => { const e=document.getElementById(id); if(e) e.textContent=v; };
  set('kpiCrop', crop ? `${CROP_DB[crop]?.emoji||'🌱'} ${crop}` : 'Not selected');
  set('kpiHealth', h ? h.label : crop ? '—' : '—');
  set('kpiDays', crop ? `${daysLeft} days` : '—');
  set('kpiSensor', S.sensorData ? '✅ Live' : 'Offline');
}

function refreshDashSensors() {
  const s = S.sensorData; if (!s) return;
  const map = {N:'ds-N',P:'ds-P',K:'ds-K',temp:'ds-T',humidity:'ds-H',moisture:'ds-M'};
  Object.entries(map).forEach(([k,id]) => { const e=document.getElementById(id); if(e) e.textContent=s[k]; });
  const ts = document.getElementById('dashSensorTs');
  if (ts) ts.textContent = `📡 Last updated: ${new Date(s.ts||Date.now()).toLocaleTimeString()} · Auto-refreshes every hour`;
  // Highlight abnormals on dashboard strip
  if (s.moisture < 35) document.getElementById('ss-M')?.classList.add('abnormal');
  if (s.temp > 35)     document.getElementById('ss-T')?.classList.add('abnormal');
  if (s.N < 25)        document.getElementById('ss-N')?.classList.add('abnormal');
  if (s.humidity > 82) document.getElementById('ss-H')?.classList.add('abnormal');
}

function initDashCharts() {
  // Disease frequency
  const dCtx = document.getElementById('dashDiseaseChart'); if (!dCtx) return;
  const topD = Object.values(DISEASE_DB).filter(d=>d.disease!=='Healthy').sort((a,b)=>b.confidence-a.confidence).slice(0,8);
  if (S.charts.dashD) S.charts.dashD.destroy();
  S.charts.dashD = new Chart(dCtx, {
    type:'bar',
    data:{ labels:topD.map(d=>d.disease), datasets:[{ label:'Detection Confidence %',
      data:topD.map(d=>d.confidence),
      backgroundColor:topD.map(d=>d.severity==='CRITICAL'?'rgba(220,38,38,.7)':d.severity==='HIGH'?'rgba(239,68,68,.6)':'rgba(245,158,11,.6)'),
      borderRadius:5 }] },
    options:{ indexAxis:'y', plugins:{legend:{display:false}}, scales:{x:{max:100}} }
  });
  // Crop success donut
  const pCtx = document.getElementById('dashSuccessChart'); if (!pCtx) return;
  if (S.charts.dashP) S.charts.dashP.destroy();
  const top5 = Object.keys(CROP_DB).slice(0,7);
  S.charts.dashP = new Chart(pCtx, {
    type:'doughnut',
    data:{ labels:top5, datasets:[{
      data:[88,82,76,90,72,85,68],
      backgroundColor:['#22c55e','#3b82f6','#f59e0b','#8b5cf6','#06b6d4','#f97316','#ec4899'],
      borderWidth:2 }] },
    options:{ plugins:{ legend:{ position:'right', labels:{font:{size:10}} } }, cutout:'55%' }
  });
}

/* ═══════════════════════════════════════════════
   NOTIFICATIONS
═══════════════════════════════════════════════ */
function initNotifications() {
  if (!S.notifications || !S.notifications.length) {
    S.notifications = [
      {type:'crit',ico:'💧',title:'Low Moisture Alert',msg:'Soil moisture at 32% — critical. Irrigate immediately.',remedy:'Apply drip irrigation 45 min. Target: 55–65%.',time:'2 min ago'},
      {type:'warn',ico:'🌡️',title:'High Temperature',msg:'Temperature 36°C exceeds optimal range for most crops.',remedy:'Apply shade net. Irrigate in early morning hours.',time:'15 min ago'},
      {type:'info',ico:'📅',title:'Fertilizer Reminder',msg:'Day 30 top-dressing due: Apply Urea 40kg/ha.',remedy:'Apply in morning. Mix with irrigation water.',time:'1 hr ago'},
    ];
  }
  renderNotifPanel();
  updateNotifBadge();
}

function addNotif(type, title, msg, time) {
  const icoMap = {crit:'🔴',warn:'🟡',ok:'✅',info:'💡'};
  const remedy = {crit:'Take immediate action.',warn:'Monitor closely.',ok:'Continue current care.',info:'Follow schedule.'}[type]||'';
  S.notifications.unshift({type, ico:icoMap[type]||'📢', title, msg, remedy, time:time||new Date().toLocaleTimeString()});
  save(); renderNotifPanel(); updateNotifBadge();
  if ('Notification' in window && Notification.permission==='granted') {
    new Notification(`SmartAgri: ${title}`, {body:msg});
  }
}

function renderNotifPanel() {
  const list = document.getElementById('notifItems'); if (!list) return;
  if (!S.notifications.length) { list.innerHTML='<p style="padding:16px;color:var(--muted);font-size:.85rem;text-align:center">No notifications</p>'; return; }
  list.innerHTML = S.notifications.slice(0,20).map(n=>`
    <div class="nd-item ${n.type}">
      <div class="nd-item-ico">${n.ico}</div>
      <div class="nd-item-body">
        <div class="nd-item-title">${n.title}</div>
        <div class="nd-item-msg">${n.msg}</div>
        ${n.remedy?`<div class="nd-item-remedy">💊 ${n.remedy}</div>`:''}
        <div class="nd-item-time">${n.time}</div>
      </div>
    </div>`).join('');
}

function updateNotifBadge() {
  const dot = document.getElementById('notifDot');
  if (dot) { if(S.notifications.length) dot.classList.add('show'); else dot.classList.remove('show'); }
}

function clearNotifs() { S.notifications=[]; save(); renderNotifPanel(); updateNotifBadge(); toast('Notifications cleared','info'); }

function generateAlerts() {
  const s = S.sensorData; if (!s) return;
  if (s.moisture < 35) addNotif('crit','💧 Low Moisture',`Soil moisture ${s.moisture}% is critically low. Irrigate now.`, new Date().toLocaleTimeString());
  if (s.temp > 35)     addNotif('warn','🌡️ High Temperature',`Temperature ${s.temp}°C exceeds crop optimal range.`, new Date().toLocaleTimeString());
  if (s.N < 25)        addNotif('warn','🧪 Low Nitrogen',`N at ${s.N} kg/ha — apply Urea 30kg/ha top-dress.`, new Date().toLocaleTimeString());
  if (s.humidity > 82) addNotif('warn','🌫️ High Humidity',`Humidity ${s.humidity}% increases fungal disease risk.`, new Date().toLocaleTimeString());
}

async function fetchWeatherForecast() {
  const weatherCard = document.getElementById('dashWeatherCard');
  if (!weatherCard) return;

  const loc = S.activeFarm ? S.activeFarm.location : 'Karnataka, India';
  
  weatherCard.innerHTML = `
    <div class="weather-widget" style="justify-content: center; padding: 30px; width: 100%;">
      <div class="spinner" style="width: 30px; height: 30px;"></div>
      <p style="margin-left: 15px; font-weight: 600; font-size: 0.9rem; color: var(--muted)">Loading forecast for ${loc}...</p>
    </div>`;

  try {
    let lat = 15.3173; 
    let lon = 75.7139; 
    let displayName = loc;
    
    // Fallback dictionary for states/regions that the geocoding API might fail to resolve
    const normalized = loc.toLowerCase().replace(/[^a-z]/g, '');
    const stateFallbacks = {
      karnataka: { lat: 12.9716, lon: 77.5946, name: 'Bengaluru, Karnataka, India' },
      punjab: { lat: 30.9010, lon: 75.8573, name: 'Ludhiana, Punjab, India' },
      maharashtra: { lat: 19.0760, lon: 72.8777, name: 'Mumbai, Maharashtra, India' },
      delhi: { lat: 28.6139, lon: 77.2090, name: 'New Delhi, Delhi, India' },
      tamilnadu: { lat: 13.0827, lon: 80.2707, name: 'Chennai, Tamil Nadu, India' },
      telangana: { lat: 17.3850, lon: 78.4867, name: 'Hyderabad, Telangana, India' },
      andhra: { lat: 16.5062, lon: 80.6480, name: 'Vijayawada, Andhra Pradesh, India' },
      rajasthan: { lat: 26.9124, lon: 75.7873, name: 'Jaipur, Rajasthan, India' },
      gujarat: { lat: 23.0225, lon: 72.5714, name: 'Ahmedabad, Gujarat, India' },
      uttarpradesh: { lat: 26.8467, lon: 80.9462, name: 'Lucknow, Uttar Pradesh, India' },
      haryana: { lat: 30.7333, lon: 76.7794, name: 'Chandigarh, Haryana, India' },
      bihar: { lat: 25.5941, lon: 85.1376, name: 'Patna, Bihar, India' },
      westbengal: { lat: 22.5726, lon: 88.3639, name: 'Kolkata, West Bengal, India' },
      kerala: { lat: 8.5241, lon: 76.9366, name: 'Trivandrum, Kerala, India' },
      madhyapradesh: { lat: 23.2599, lon: 77.4126, name: 'Bhopal, Madhya Pradesh, India' }
    };

    let matchedFallback = null;
    let isPureState = false;
    for (const key in stateFallbacks) {
      if (normalized === key || normalized === key + 'india') {
        matchedFallback = stateFallbacks[key];
        isPureState = true;
        break;
      }
    }

    let geocodingSuccess = false;
    if (isPureState && matchedFallback) {
      lat = matchedFallback.lat;
      lon = matchedFallback.lon;
      displayName = matchedFallback.name;
    } else {
      // Construct robust list of search candidates
      const searchCandidates = [];
      if (loc.includes(',')) {
        const firstSegment = loc.split(',')[0].trim();
        if (firstSegment.length > 0) {
          searchCandidates.push(firstSegment);
        }
      }
      searchCandidates.push(loc.trim());
      const words = loc.trim().split(/\s+/);
      if (words.length > 1 && words[0].length > 0) {
        searchCandidates.push(words[0]);
      }
      
      // De-duplicate candidates
      const uniqueCandidates = [...new Set(searchCandidates)];

      for (const candidate of uniqueCandidates) {
        try {
          const geoUrl = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(candidate)}&count=1&language=en&format=json`;
          const geoRes = await fetch(geoUrl);
          const geoData = await geoRes.json();
          
          if (geoData.results && geoData.results.length > 0) {
            const first = geoData.results[0];
            lat = first.latitude;
            lon = first.longitude;
            displayName = `${first.name}${first.admin1 ? ', ' + first.admin1 : ''}, ${first.country}`;
            geocodingSuccess = true;
            break; // Success, exit candidate loop
          }
        } catch (e) {
          console.error(`Geocoding failed for candidate '${candidate}':`, e);
        }
      }

      if (!geocodingSuccess) {
        for (const key in stateFallbacks) {
          if (normalized.includes(key)) {
            matchedFallback = stateFallbacks[key];
            break;
          }
        }
        if (matchedFallback) {
          lat = matchedFallback.lat;
          lon = matchedFallback.lon;
          displayName = matchedFallback.name;
        }
      }
    }

    const weatherUrl = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&daily=precipitation_probability_max,precipitation_sum,temperature_2m_max&timezone=auto&current_weather=true`;
    const weatherRes = await fetch(weatherUrl);
    const weatherData = await weatherRes.json();

    if (!weatherData.daily) throw new Error('Invalid weather data');

    const current = weatherData.current_weather || {};
    const daily = weatherData.daily;
    
    const rainProbabilities = daily.precipitation_probability_max || [];
    const rainSums = daily.precipitation_sum || [];
    const maxRainProb = Math.max(...rainProbabilities, 0);
    const totalRainSum = rainSums.reduce((a, b) => a + b, 0);

    let outlook = 'normal';
    if (maxRainProb >= 60 || totalRainSum >= 20) {
      outlook = 'wet';
    } else if (maxRainProb < 20 && totalRainSum < 5) {
      outlook = 'dry';
    }

    S.weatherOutlook = {
      outlook,
      maxRainProb,
      totalRainSum,
      temp: current.temperature || daily.temperature_2m_max[0] || 28.5,
      displayName,
      todayRainProb: rainProbabilities[0] || 0
    };
    save();

    renderWeatherWidget();
    renderWeatherBanners();

  } catch (error) {
    console.error('Error fetching weather forecast:', error);
    weatherCard.innerHTML = `
      <div class="weather-widget">
        <div class="ww-left">
          <div style="font-size: 2rem;">⚠️</div>
          <div class="ww-info">
            <div class="ww-title">Weather Unavailable</div>
            <div class="ww-desc">Could not load live forecast for "${loc}".</div>
          </div>
        </div>
        <button class="btn-primary" style="padding: 6px 12px; font-size: 0.78rem" onclick="fetchWeatherForecast()">Retry</button>
      </div>`;
  }
}

function renderWeatherWidget() {
  const weatherCard = document.getElementById('dashWeatherCard');
  if (!weatherCard || !S.weatherOutlook) return;

  const w = S.weatherOutlook;
  const emojiMap = { wet: '🌧️', dry: '☀️', normal: '🌤️' };
  const badgeClassMap = { wet: 'wet', dry: 'dry', normal: 'normal' };
  const badgeLabelMap = { wet: 'Wet Outlook', dry: 'Dry Outlook', normal: 'Moderate Weather' };

  weatherCard.innerHTML = `
    <div class="weather-widget">
      <div class="ww-left">
        <div class="ww-temp-box">
          <div class="ww-temp">${Math.round(w.temp)}°C</div>
          <div class="ww-cond-label">${emojiMap[w.outlook]} Live Weather</div>
        </div>
        <div class="ww-info">
          <div class="ww-title">${w.displayName}</div>
          <div class="ww-desc">7-Day Outlook: Max rain probability is <strong>${w.maxRainProb}%</strong> (Total: ${w.totalRainSum.toFixed(1)}mm)</div>
          <div class="ww-rain-prob">☔ Today's Rain Probability: ${w.todayRainProb}%</div>
        </div>
      </div>
      <div class="ww-right">
        <span class="ww-badge ${badgeClassMap[w.outlook]}">${badgeLabelMap[w.outlook]}</span>
      </div>
    </div>`;
}

function renderWeatherBanners() {
  const w = S.weatherOutlook;
  const bannerContainer = document.getElementById('recommendationWeatherBanner');
  
  if (bannerContainer) {
    if (!w) {
      bannerContainer.innerHTML = '';
    } else if (w.outlook === 'wet') {
      bannerContainer.innerHTML = `
        <div class="weather-banner wet">
          <span class="wb-ico">🌧️</span>
          <div>
            <strong>Rainy Season Approaching!</strong>
            <p>A wet period is expected soon (Max rain probability: ${w.maxRainProb}%). This is the perfect time to sow crops that need high water (e.g. Rice, Jute). Dry crops are not suitable now.</p>
          </div>
          <button class="wb-btn" onclick="document.getElementById('recStep1').scrollIntoView({behavior:'smooth'})">Sow Now</button>
        </div>`;
    } else if (w.outlook === 'dry') {
      bannerContainer.innerHTML = `
        <div class="weather-banner">
          <span class="wb-ico">☀️</span>
          <div>
            <strong>Dry Weather Approaching!</strong>
            <p>Dry, sunny conditions are forecasted (Max rain probability: ${w.maxRainProb}%). We recommend sowing drought-tolerant crops (e.g. Groundnut, Sunflower, Mustard). High-water crops are not suitable.</p>
          </div>
          <button class="wb-btn" style="background: var(--a2);" onclick="document.getElementById('recStep1').scrollIntoView({behavior:'smooth'})">Plan Sowing</button>
        </div>`;
    } else {
      bannerContainer.innerHTML = '';
    }
  }

  const mainContent = document.getElementById('maintenanceContent');
  if (!S.selectedCrop && mainContent) {
    let weatherSnippet = '';
    if (w) {
      if (w.outlook === 'wet') {
        weatherSnippet = `
          <div style="margin-top: 20px; background: var(--g6); border: 1px solid var(--border); padding: 14px; border-radius: 10px; display: inline-flex; align-items: center; gap: 12px; max-width: 500px; text-align: left;">
            <span style="font-size: 2rem;">🌧️</span>
            <div>
              <strong style="color: var(--g1)">Wet Outlook for ${w.displayName}</strong>
              <p style="font-size: 0.8rem; margin: 4px 0 0; color: var(--text2)">Heavy rain is forecasted (Max rain prob: ${w.maxRainProb}%). This is the optimal time to sow water-loving crops.</p>
            </div>
          </div>`;
      } else if (w.outlook === 'dry') {
        weatherSnippet = `
          <div style="margin-top: 20px; background: var(--a5); border: 1px solid var(--a4); padding: 14px; border-radius: 10px; display: inline-flex; align-items: center; gap: 12px; max-width: 500px; text-align: left;">
            <span style="font-size: 2rem;">☀️</span>
            <div>
              <strong style="color: var(--a1)">Dry Outlook for ${w.displayName}</strong>
              <p style="font-size: 0.8rem; margin: 4px 0 0; color: var(--text2)">Dry weather is expected (Max rain prob: ${w.maxRainProb}%). Prepare soil and select drought-tolerant crops.</p>
            </div>
          </div>`;
      }
    }

    mainContent.innerHTML = `
      <div class="no-crop-box">
        <div class="ncb-ico">🌱</div>
        <h3>No crop selected yet</h3>
        <p>Go to Crop Recommendation, scan your soil, and select a crop to begin monitoring.</p>
        <button class="btn-primary" onclick="goTo('recommendation')">🌱 Go to Crop Recommendation →</button>
        <br/>
        ${weatherSnippet}
      </div>`;
  }
}

/* ═══════════════════════════════════════════════
   INIT ON LOAD
═══════════════════════════════════════════════ */

document.addEventListener('DOMContentLoaded', () => {
  load();
  if (S.user) { initApp(); } 
  else { document.getElementById('authScreen').style.display = 'flex'; }
});
