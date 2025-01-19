CREATE TABLE back_up (
    id_back_up INT AUTO_INCREMENT PRIMARY KEY,
    id_original_table INT,
    backup_date DATE,
    backup_type VARCHAR(50),
    FOREIGN KEY (id_original_table) REFERENCES klijenti(id_klijent)
);


CREATE TABLE troskovi_datacenter (
    id_troskovi INT AUTO_INCREMENT PRIMARY KEY,
    datum DATE,
    iznos FLOAT,
    opis VARCHAR(255),
    id_klijent INT,
    FOREIGN KEY (id_klijent) REFERENCES klijenti(id_klijent)
);


CREATE TABLE oprema_procedure (
    id_opreme_procedure INT AUTO_INCREMENT PRIMARY KEY,
    id_oprema INT,
    id_procedura INT,
    datum_procedure DATE,
    rezultati TEXT,
    FOREIGN KEY (id_oprema) REFERENCES oprema(id),
    FOREIGN KEY (id_procedura) REFERENCES Procedure(id)
);

INSERT INTO back_up (id_original_table, backup_date, backup_type)
VALUES 
(1, '2024-01-15', 'FULL'),
(2, '2024-01-12', 'INCREMENTAL'),
(3, '2024-01-18', 'DIFFERENTIAL');


INSERT INTO troskovi_datacenter (datum, iznos, opis, id_klijent)
VALUES 
('2024-01-01', 5000.00, 'Monthly rent payment', 1),
('2024-01-05', 1500.00, 'Electricity bill', 2),
('2024-01-10', 800.00, 'Internet subscription', 3);


INSERT INTO oprema_procedure (id_opreme, id_procedura, datum_procedure, rezultati)
VALUES 
(1, 1, '2024-01-02', 'Processor speed optimized'),
(2, 2, '2024-01-03', 'Memory upgraded'),
(3, 3, '2024-01-04', 'Cooling system serviced');
DELIMITER //

CREATE PROCEDURE create_client_backup()
BEGIN
    DECLARE @id_original_table INT;
    SET @id_original_table = (SELECT id_klijent FROM klijenti ORDER BY id_klijent DESC LIMIT 1);
    
    INSERT INTO back_up (id_original_table, backup_date, backup_type)
    VALUES (@id_original_table, CURDATE(), 'FULL');
END //

DELIMITER ;

-- Procedure to record data center expenses
DELIMITER //

CREATE PROCEDURE record_expense()
BEGIN
    DECLARE @client_id INT;
    SET @client_id = (SELECT id_klijent FROM klijenti ORDER BY RAND() LIMIT 1);
    
    INSERT INTO troskovi_datacenter (datum, iznos, opis, id_klijent)
    VALUES (CURDATE(), ROUND(RAND() * 1000, 2), 'Random expense', @client_id);
END //

DELimiter ;

-- Procedure to update equipment procedure
DELIMITER //

CREATE PROCEDURE update_equipment_procedure()
BEGIN
    DECLARE @equipment_id INT;
    SET @equipment_id = (SELECT id FROM oprema ORDER BY RAND() LIMIT 1);
    
    UPDATE oprema
    SET stanje_na_zalihama = stanje_na_zalihama + 1
    WHERE id = @equipment_id;
    
    INSERT INTO oprema_procedure (id_oprema, id_procedura, datum_procedure, rezultati)
    VALUES (@equipment_id, 1, CURDATE(), 'Equipment checked and updated');
END //

DELIMITER ;
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<div class="container-fluid">
  <div class="row">
    <div class="col-md-8">
      <!--  -->
    </div>
    <div class="col-md-4">
      <!--  -->
    </div>
  </div>
</div>

document.getElementById('myModal').addEventListener('show.bs.modal', function (event) {
  //
});

document.getElementById('myCollapse').addEventListener('shown.bs.collapse', function (event) {
  // 
});

<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">Launch demo modal</button>

// 
function displayBackups() {
    const backUpsContainer = document.getElementById('backUpsContainer');
    backUpsContainer.innerHTML = '';

    fetch('/api/backUps')
        .then(response => response.json())
        .then(data => {
            data.forEach(backUp => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${backUp.id_original_table}</td>
                    <td>${new Date(backUp.backup_date).toLocaleDateString()}</td>
                    <td>${backUp.backup_type}</td>
                    <td><button class="deleteButton" data-id="${backUp.id_back_up}">Delete</button></td>
                `;
                backUpsContainer.appendChild(row);
            });
        })
        .catch(error => console.error('Error:', error));
}

//
function addBackUp() {
    const idOriginalTable = document.getElementById('idOriginalTable').value;
    const backupDate = document.getElementById('backupDate').value;
    const backupType = document.getElementById('backupType').value;

    fetch('/api/backUps', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id_original_table: idOriginalTable, backup_date: backupDate, backup_type: backupType }),
    })
        .then(response => response.json())
        .then(data => {
            displayBackUps();
            alert('Back-up added successfully!');
        })
        .catch(error => console.error('Error:', error));
}

// 
function deleteBackUp(id) {
    fetch(`/api/backUps/${id}`, { method: 'DELETE' })
        .then(() => {
            displayBackUps();
            alert('Back-up deleted successfully!');
        })
        .catch(error => console.error('Error:', error));
}

function displayExpenses() {
    const expensesContainer = document.getElementById('expensesContainer');
    expensesContainer.innerHTML = '';

    fetch('/api/expenses')
        .then(response => response.json())
        .then(data => {
            data.forEach(expense => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${new Date(expense.datum).toLocaleDateString()}</td>
                    <td>${expense.iznos.toFixed(2)}</td>
                    <td>${expense.opis}</td>
                    <td><button class="deleteButton" data-id="${expense.id_troskovi}">Delete</button></td>
                `;
                expensesContainer.appendChild(row);
            });
        })
        .catch(error => console.error('Error:', error));
}

// 
function addExpense() {
    const date = document.getElementById('date').value;
    const amount = parseFloat(document.getElementById('amount').value);
    const description = document.getElementById('description').value;
    const clientId = document.getElementById('clientId').value;

    fetch('/api/expenses', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ datum: date, iznos: amount, opis: description, id_klijent: clientId }),
    })
        .then(response => response.json())
        .then(data => {
            displayExpenses();
            alert('Expense added successfully!');
        })
        .catch(error => console.error('Error:', error));
}

// 
function deleteExpense(id) {
    fetch(`/api/expenses/${id}`, { method: 'DELETE' })
        .then(() => {
            displayExpenses();
            alert('Expense deleted successfully!');
        })
        .catch(error => console.error('Error:', error));
        
        // 
function displayEquipmentProcedures() {
    const proceduresContainer = document.getElementById('proceduresContainer');
    proceduresContainer.innerHTML = '';

    fetch('/api/equipmentProcedures')
        .then(response => response.json())
        .then(data => {
            data.forEach(procedure => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${procedure.id_opreme}</td>
                    <td>${procedure.id_procedura}</td>
                    <td>${new Date(procedure.datum_procedure).toLocaleDateString()}</td>
                    <td>${procedure.rezultati}</td>
                    <td><button class="deleteButton" data-id="${procedure.id_opreme_procedure}">Delete</button></td>
                `;
                proceduresContainer.appendChild(row);
            });
        })
        .catch(error => console.error('Error:', error));
}


function addEquipmentProcedure() {
    const equipmentId = document.getElementById('equipmentId').value;
    const procedureId = document.getElementById('procedureId').value;
    const date = document.getElementById('date').value;
    const results = document.getElementById('results').value;

    fetch('/api/equipmentProcedures', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id_opreme: equipmentId, id_procedura: procedureId, datum_procedure: date, rezultati: results }),
    })
        .then(response => response.json())
        .then(data => {
            displayEquipmentProcedures();
            alert('Equipment procedure added successfully!');
        })
        .catch(error => console.error('Error:', error));
}


function deleteEquipmentProcedure(id) {
    fetch(`/api/equipmentProcedures/${id}`, { method: 'DELETE' })
        .then(() => {
            displayEquipmentProcedures();
            alert('Equipment procedure deleted successfully!');
        })
        .catch(error => console.error('Error:', error));
}
