﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using eServisnaKnjiga.Services.Database;

#nullable disable

namespace eServisnaKnjiga.Services.Migrations
{
    [DbContext(typeof(EServisnaKnjigaContext))]
    partial class EServisnaKnjigaContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.10")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Automobil", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("BrojSasije")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("broj_sasije");

                    b.Property<int?>("GodinaProizvodnje")
                        .HasColumnType("int")
                        .HasColumnName("godina_proizvodnje");

                    b.Property<int?>("KlijentId")
                        .HasColumnType("int")
                        .HasColumnName("klijent_id");

                    b.Property<string>("Marka")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("marka");

                    b.Property<string>("Model")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("model");

                    b.Property<string>("Registracija")
                        .HasMaxLength(20)
                        .IsUnicode(false)
                        .HasColumnType("varchar(20)")
                        .HasColumnName("registracija");

                    b.HasKey("Id")
                        .HasName("PK__Automobi__3213E83FA92C638F");

                    b.HasIndex("KlijentId");

                    b.ToTable("Automobil", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Klijent", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Adresa")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)")
                        .HasColumnName("adresa");

                    b.Property<string>("Email")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)")
                        .HasColumnName("email");

                    b.Property<string>("Ime")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("ime");

                    b.Property<string>("Prezime")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("prezime");

                    b.Property<string>("Telefon")
                        .HasMaxLength(20)
                        .IsUnicode(false)
                        .HasColumnType("varchar(20)")
                        .HasColumnName("telefon");

                    b.HasKey("Id")
                        .HasName("PK__Klijent__3213E83F3B8FE3CE");

                    b.ToTable("Klijent", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Korisnici", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Email")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)")
                        .HasColumnName("email");

                    b.Property<int?>("KlijentId")
                        .HasColumnType("int")
                        .HasColumnName("klijent_id");

                    b.Property<string>("Lozinka")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("lozinka");

                    b.Property<int?>("RoleId")
                        .HasColumnType("int")
                        .HasColumnName("role_id");

                    b.HasKey("Id")
                        .HasName("PK__Korisnic__3213E83FCF69A1F7");

                    b.HasIndex("KlijentId");

                    b.HasIndex("RoleId");

                    b.ToTable("Korisnici", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Majstori", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("DatumRodjenja")
                        .HasColumnType("date")
                        .HasColumnName("datum_rodjenja");

                    b.Property<string>("Ime")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("ime");

                    b.Property<string>("Prezime")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("prezime");

                    b.HasKey("Id")
                        .HasName("PK__Majstori__3213E83FF987DA26");

                    b.ToTable("Majstori", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Novosti", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("DatumObjave")
                        .HasColumnType("date")
                        .HasColumnName("datum_objave");

                    b.Property<string>("Naslov")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)")
                        .HasColumnName("naslov");

                    b.Property<string>("Tekst")
                        .IsUnicode(false)
                        .HasColumnType("varchar(max)")
                        .HasColumnName("tekst");

                    b.HasKey("Id")
                        .HasName("PK__Novosti__3213E83F9F55FF85");

                    b.ToTable("Novosti", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Obavjesti", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("date")
                        .HasColumnName("datum");

                    b.Property<int?>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("korisnik_id");

                    b.Property<int?>("PaketId")
                        .HasColumnType("int")
                        .HasColumnName("paket_id");

                    b.HasKey("Id")
                        .HasName("PK__Obavjest__3213E83F87759CA9");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("PaketId");

                    b.ToTable("Obavjesti", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Paketi", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("IntervalObavjesti")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("interval_obavjesti");

                    b.Property<decimal?>("MaksimalnaCijena")
                        .HasColumnType("decimal(10, 2)")
                        .HasColumnName("maksimalna_cijena");

                    b.Property<decimal?>("MinimalnaCijena")
                        .HasColumnType("decimal(10, 2)")
                        .HasColumnName("minimalna_cijena");

                    b.Property<string>("Naziv")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("naziv");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)")
                        .HasColumnName("opis");

                    b.HasKey("Id")
                        .HasName("PK__Paketi__3213E83F82502657");

                    b.ToTable("Paketi", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.RadniNalog", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<decimal?>("Cijena")
                        .HasColumnType("decimal(10, 2)")
                        .HasColumnName("cijena");

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("date")
                        .HasColumnName("datum");

                    b.Property<int?>("MajstorId")
                        .HasColumnType("int")
                        .HasColumnName("majstor_id");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)")
                        .HasColumnName("opis");

                    b.Property<int?>("RezervacijaId")
                        .HasColumnType("int")
                        .HasColumnName("rezervacija_id");

                    b.HasKey("Id")
                        .HasName("PK__RadniNal__3213E83F4F68FAB9");

                    b.HasIndex("MajstorId");

                    b.HasIndex("RezervacijaId");

                    b.ToTable("RadniNalog", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.RezervacijaPaketi", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("PaketId")
                        .HasColumnType("int")
                        .HasColumnName("paket_id");

                    b.Property<int>("RezervacijaId")
                        .HasColumnType("int")
                        .HasColumnName("rezervacija_id");

                    b.HasKey("Id")
                        .HasName("PK__Rezervac__3213E83FCDD2A378");

                    b.HasIndex("PaketId");

                    b.HasIndex("RezervacijaId");

                    b.ToTable("Rezervacija_Paketi", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Rezervacije", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int?>("AutomobilId")
                        .HasColumnType("int")
                        .HasColumnName("automobil_id");

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("date")
                        .HasColumnName("datum");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)")
                        .HasColumnName("opis");

                    b.Property<string>("Status")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("status");

                    b.HasKey("Id")
                        .HasName("PK__Rezervac__3213E83F896D2872");

                    b.HasIndex("AutomobilId");

                    b.ToTable("Rezervacije", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Role", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)")
                        .HasColumnName("naziv");

                    b.HasKey("Id")
                        .HasName("PK__Role__3213E83F658D240A");

                    b.ToTable("Role", (string)null);
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Automobil", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Klijent", "Klijent")
                        .WithMany("Automobils")
                        .HasForeignKey("KlijentId")
                        .HasConstraintName("FK__Automobil__klije__76969D2E");

                    b.Navigation("Klijent");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Korisnici", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Klijent", "Klijent")
                        .WithMany("Korisnicis")
                        .HasForeignKey("KlijentId")
                        .HasConstraintName("FK__Korisnici__klije__7F2BE32F");

                    b.HasOne("eServisnaKnjiga.Services.Database.Role", "Role")
                        .WithMany("Korisnicis")
                        .HasForeignKey("RoleId")
                        .HasConstraintName("FK__Korisnici__role___00200768");

                    b.Navigation("Klijent");

                    b.Navigation("Role");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Obavjesti", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Korisnici", "Korisnik")
                        .WithMany("Obavjestis")
                        .HasForeignKey("KorisnikId")
                        .HasConstraintName("FK__Obavjesti__koris__10566F31");

                    b.HasOne("eServisnaKnjiga.Services.Database.Paketi", "Paket")
                        .WithMany("Obavjestis")
                        .HasForeignKey("PaketId")
                        .HasConstraintName("FK__Obavjesti__paket__114A936A");

                    b.Navigation("Korisnik");

                    b.Navigation("Paket");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.RadniNalog", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Majstori", "Majstor")
                        .WithMany("RadniNalogs")
                        .HasForeignKey("MajstorId")
                        .HasConstraintName("FK__RadniNalo__majst__1AD3FDA4");

                    b.HasOne("eServisnaKnjiga.Services.Database.Rezervacije", "Rezervacija")
                        .WithMany("RadniNalogs")
                        .HasForeignKey("RezervacijaId")
                        .HasConstraintName("FK__RadniNalo__rezer__1BC821DD");

                    b.Navigation("Majstor");

                    b.Navigation("Rezervacija");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.RezervacijaPaketi", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Paketi", "Paket")
                        .WithMany("RezervacijaPaketis")
                        .HasForeignKey("PaketId")
                        .IsRequired()
                        .HasConstraintName("FK__Rezervaci__paket__1EA48E88");

                    b.HasOne("eServisnaKnjiga.Services.Database.Rezervacije", "Rezervacija")
                        .WithMany("RezervacijaPaketis")
                        .HasForeignKey("RezervacijaId")
                        .IsRequired()
                        .HasConstraintName("FK__Rezervaci__rezer__1F98B2C1");

                    b.Navigation("Paket");

                    b.Navigation("Rezervacija");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Rezervacije", b =>
                {
                    b.HasOne("eServisnaKnjiga.Services.Database.Automobil", "Automobil")
                        .WithMany("Rezervacijes")
                        .HasForeignKey("AutomobilId")
                        .HasConstraintName("FK__Rezervaci__autom__17F790F9");

                    b.Navigation("Automobil");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Automobil", b =>
                {
                    b.Navigation("Rezervacijes");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Klijent", b =>
                {
                    b.Navigation("Automobils");

                    b.Navigation("Korisnicis");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Korisnici", b =>
                {
                    b.Navigation("Obavjestis");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Majstori", b =>
                {
                    b.Navigation("RadniNalogs");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Paketi", b =>
                {
                    b.Navigation("Obavjestis");

                    b.Navigation("RezervacijaPaketis");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Rezervacije", b =>
                {
                    b.Navigation("RadniNalogs");

                    b.Navigation("RezervacijaPaketis");
                });

            modelBuilder.Entity("eServisnaKnjiga.Services.Database.Role", b =>
                {
                    b.Navigation("Korisnicis");
                });
#pragma warning restore 612, 618
        }
    }
}
