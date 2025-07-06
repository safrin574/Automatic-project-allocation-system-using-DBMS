
# 🎓 Automatic Student Project Allocation System

## 🔍 Problem Statement
Manual allocation of student projects often leads to inefficiencies, bias, and uneven project distribution. This system automates the allocation of student projects based on availability and predefined constraints using SQL procedures and triggers.

## ✅ Objectives
- Automatically assign projects to students based on availability.
- Ensure that no project exceeds the maximum number of students.
- Provide a dashboard view linking students, their projects, and assigned advisors.
- Maintain data integrity using triggers and stored procedures.

## 🛠️ Tech Stack
- MySQL
- SQL Procedures and Triggers
- Views for Dashboard
- MySQL Workbench for execution

## 📁 Database Schema

### Tables:
- **Students(StudentID, StudentName)**
- **Advisors(AdvisorID, AdvisorName, Department)**
- **Projects(ProjectID, ProjectTitle, MaxStudents, AdvisorID)**
- **ProjectAllocations(AllocationID, StudentID, ProjectID)**

### Views:
- `StudentProjectDashboard`: A comprehensive view showing student, project, and advisor info.

## ⚙️ Key Features

- **Stored Procedures**  
  `AddAdvisor`, `AddProject`, `Students` to handle inserts and automatic allocation.

- **Trigger**  
  `trg_BeforeInsertAllocation` to prevent project over-allocation.

- **Random Allocation Logic**  
  Allocates students randomly to available projects within the capacity limits.

## 🧪 How to Run

1. Execute the SQL script in a MySQL environment.
2. Procedures will auto-create and populate tables.
3. Call `CALL Students('Student Name')` to allocate a new student.
4. Query `SELECT * FROM StudentProjectDashboard` to view the live project allocation status.

## 📊 Sample Output Columns
| StudentID | StudentName | ProjectID | ProjectTitle | AdvisorID | AdvisorName | Department |
|-----------|-------------|-----------|---------------|-----------|--------------|------------|

## 🔐 Constraints
- Each project can have a maximum of 3 students.
- Project allocation is blocked if the limit is reached (via trigger).
- Advisors and projects are added via stored procedures to maintain consistency.

## 🧠 Future Enhancements
- Web UI for student and faculty interaction.
- Option for students to list project preferences.
- Allocation based on skill matching or preference scoring.

## 👩‍💻 Author
**Safrin M**  
AI & Data Science Student
