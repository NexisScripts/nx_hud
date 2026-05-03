window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "showUI") {
        document.getElementById('ui-container').style.display = 'block';
    }

    // Update Player Info (ID, Job, Cash, Bank)
    if (data.action === "updateInfo") {
        document.getElementById('player-id').innerText = data.id;
        document.getElementById('player-job').innerText = data.job;

        // Auto-format large numbers (e.g., 100000 -> 100,000)
        let formatter = new Intl.NumberFormat('en-US');
        document.getElementById('player-cash').innerText = formatter.format(data.cash);
        document.getElementById('player-bank').innerText = formatter.format(data.bank);

        document.getElementById('info-hud-container').style.display = 'flex';
    }

    // Update Player Status Bars
    if (data.action === "updateStatus") {
        document.getElementById('health-bar').style.width = data.health + "%";
        document.getElementById('armor-bar').style.width = data.armor + "%";
        document.getElementById('stamina-bar').style.width = data.stamina + "%";
    }

    // Update Hunger and Thirst
    if (data.action === "updateNeeds") {
        document.getElementById('hunger-bar').style.width = Math.round(data.hunger) + "%";
        document.getElementById('thirst-bar').style.width = Math.round(data.thirst) + "%";
    }

    // Toggle Vehicle HUD Visibility
    if (data.action === "showCarHUD") {
        document.getElementById('car-hud-container').style.display = 'flex';
    }

    if (data.action === "hideCarHUD") {
        document.getElementById('car-hud-container').style.display = 'none';
    }

    // Update Vehicle Telemetry
    if (data.action === "updateVehicle") {
        document.getElementById('speed-val').innerText = data.speed;
        
        let gearDisplay = data.gear;
        if (data.gear === 0) gearDisplay = "R";
        document.getElementById('gear-val').innerText = gearDisplay;

        // Calculate and update RPM Ring
        const rpmFill = document.getElementById('rpm-bar');
        const offset = 339 - (339 * data.rpm) / 100;
        rpmFill.style.strokeDashoffset = offset;
        
        // Redline effect
        if (data.rpm > 80) { rpmFill.style.stroke = "#ff4757"; } else { rpmFill.style.stroke = "#2ed573"; }

        document.getElementById('fuel-bar').style.width = data.fuel + "%";

        // Check Engine health logic & colors
        let engineBar = document.getElementById('engine-health-bar');
        engineBar.style.width = data.engineHealth + "%";
        if (data.engineHealth > 70) {
            engineBar.style.background = "#2ed573"; // Green
        } else if (data.engineHealth > 40) {
            engineBar.style.background = "#ffa502"; // Yellow
        } else {
            engineBar.style.background = "#ff4757"; // Red
        }

        // Toggle Icons (Engine and Seatbelt)
        let engineIcon = document.getElementById('engine-icon');
        let beltIcon = document.getElementById('belt-icon');

        if (data.engine) { engineIcon.classList.remove('warn'); engineIcon.classList.add('off'); } 
        else { engineIcon.classList.remove('off'); engineIcon.classList.add('warn'); } 

        if (data.belt) { beltIcon.classList.remove('warn'); beltIcon.classList.add('off'); } 
        else { beltIcon.classList.remove('off'); beltIcon.classList.add('warn'); } 
    }
});

// Notify Lua Client that NUI is fully loaded to prevent Race Conditions
window.addEventListener('load', function() {
    fetch(`https://${GetParentResourceName()}/nuiReady`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    }).catch(err => console.log("NUI Ready Error:", err));
});