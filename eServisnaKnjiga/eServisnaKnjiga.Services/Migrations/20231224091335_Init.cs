using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eServisnaKnjiga.Services.Migrations
{
    /// <inheritdoc />
    public partial class Init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Klijent",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    telefon = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: true),
                    email = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    adresa = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Klijent__3213E83F3B8FE3CE", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Majstori",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    datum_rodjenja = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Majstori__3213E83FF987DA26", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Novosti",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naslov = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    tekst = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    datum_objave = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Novosti__3213E83F9F55FF85", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Paketi",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    minimalna_cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    maksimalna_cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    interval_obavjesti = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Paketi__3213E83F82502657", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Role",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Role__3213E83F658D240A", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Automobil",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    marka = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    model = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    godina_proizvodnje = table.Column<int>(type: "int", nullable: true),
                    registracija = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: true),
                    broj_sasije = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    klijent_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Automobi__3213E83FA92C638F", x => x.id);
                    table.ForeignKey(
                        name: "FK__Automobil__klije__76969D2E",
                        column: x => x.klijent_id,
                        principalTable: "Klijent",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    email = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    lozinka = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    klijent_id = table.Column<int>(type: "int", nullable: true),
                    role_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__3213E83FCF69A1F7", x => x.id);
                    table.ForeignKey(
                        name: "FK__Korisnici__klije__7F2BE32F",
                        column: x => x.klijent_id,
                        principalTable: "Klijent",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK__Korisnici__role___00200768",
                        column: x => x.role_id,
                        principalTable: "Role",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacije",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    automobil_id = table.Column<int>(type: "int", nullable: true),
                    datum = table.Column<DateTime>(type: "date", nullable: true),
                    opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    status = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Rezervac__3213E83F896D2872", x => x.id);
                    table.ForeignKey(
                        name: "FK__Rezervaci__autom__17F790F9",
                        column: x => x.automobil_id,
                        principalTable: "Automobil",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "Obavjesti",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    paket_id = table.Column<int>(type: "int", nullable: true),
                    korisnik_id = table.Column<int>(type: "int", nullable: true),
                    datum = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Obavjest__3213E83F87759CA9", x => x.id);
                    table.ForeignKey(
                        name: "FK__Obavjesti__koris__10566F31",
                        column: x => x.korisnik_id,
                        principalTable: "Korisnici",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK__Obavjesti__paket__114A936A",
                        column: x => x.paket_id,
                        principalTable: "Paketi",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "RadniNalog",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    rezervacija_id = table.Column<int>(type: "int", nullable: true),
                    majstor_id = table.Column<int>(type: "int", nullable: true),
                    datum = table.Column<DateTime>(type: "date", nullable: true),
                    opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__RadniNal__3213E83F4F68FAB9", x => x.id);
                    table.ForeignKey(
                        name: "FK__RadniNalo__majst__1AD3FDA4",
                        column: x => x.majstor_id,
                        principalTable: "Majstori",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK__RadniNalo__rezer__1BC821DD",
                        column: x => x.rezervacija_id,
                        principalTable: "Rezervacije",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacija_Paketi",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    rezervacija_id = table.Column<int>(type: "int", nullable: false),
                    paket_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Rezervac__3213E83FCDD2A378", x => x.id);
                    table.ForeignKey(
                        name: "FK__Rezervaci__paket__1EA48E88",
                        column: x => x.paket_id,
                        principalTable: "Paketi",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK__Rezervaci__rezer__1F98B2C1",
                        column: x => x.rezervacija_id,
                        principalTable: "Rezervacije",
                        principalColumn: "id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Automobil_klijent_id",
                table: "Automobil",
                column: "klijent_id");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_klijent_id",
                table: "Korisnici",
                column: "klijent_id");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_role_id",
                table: "Korisnici",
                column: "role_id");

            migrationBuilder.CreateIndex(
                name: "IX_Obavjesti_korisnik_id",
                table: "Obavjesti",
                column: "korisnik_id");

            migrationBuilder.CreateIndex(
                name: "IX_Obavjesti_paket_id",
                table: "Obavjesti",
                column: "paket_id");

            migrationBuilder.CreateIndex(
                name: "IX_RadniNalog_majstor_id",
                table: "RadniNalog",
                column: "majstor_id");

            migrationBuilder.CreateIndex(
                name: "IX_RadniNalog_rezervacija_id",
                table: "RadniNalog",
                column: "rezervacija_id");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_Paketi_paket_id",
                table: "Rezervacija_Paketi",
                column: "paket_id");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_Paketi_rezervacija_id",
                table: "Rezervacija_Paketi",
                column: "rezervacija_id");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacije_automobil_id",
                table: "Rezervacije",
                column: "automobil_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Novosti");

            migrationBuilder.DropTable(
                name: "Obavjesti");

            migrationBuilder.DropTable(
                name: "RadniNalog");

            migrationBuilder.DropTable(
                name: "Rezervacija_Paketi");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Majstori");

            migrationBuilder.DropTable(
                name: "Paketi");

            migrationBuilder.DropTable(
                name: "Rezervacije");

            migrationBuilder.DropTable(
                name: "Role");

            migrationBuilder.DropTable(
                name: "Automobil");

            migrationBuilder.DropTable(
                name: "Klijent");
        }
    }
}
