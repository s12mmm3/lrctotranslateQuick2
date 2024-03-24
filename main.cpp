#include "operatemgr.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
// #include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    // QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    OperateMgr operateMgr;
    engine.rootContext()->setContextProperty("$operateMgr", &operateMgr);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("lrctotranslateQuick2", "Main");

    return app.exec();
}
